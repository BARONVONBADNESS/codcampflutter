import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum LoginMethod { app, discord }

enum DeliveryPreference { app, discord }

// ── User record ───────────────────────────────────────────────────────────────

class UserRecord {
  final String userId;
  final String? callsign;
  final String? email;
  final String? discordId;
  final String? discordUsername;
  final String? discordAvatar;   // avatar hash from Discord

  const UserRecord({
    required this.userId,
    this.callsign,
    this.email,
    this.discordId,
    this.discordUsername,
    this.discordAvatar,
  });

  /// Display name — Discord username if present, callsign if not.
  String get displayName =>
      discordUsername ?? callsign ?? 'GHOSTCAMPER';

  /// Full Discord avatar URL, or null if no custom avatar.
  String? get discordAvatarUrl {
    if (discordId == null || discordAvatar == null) return null;
    final ext = discordAvatar!.startsWith('a_') ? 'gif' : 'png';
    return 'https://cdn.discordapp.com/avatars/$discordId/$discordAvatar.$ext?size=256';
  }

  /// True when both login methods have been used on this device.
  bool get hasBothMethods => discordId != null && callsign != null;
}

// ── AuthService ───────────────────────────────────────────────────────────────
//
// Persistence keys (all stored in shared_preferences):
//   auth_is_logged_in       bool
//   auth_login_method       'app' | 'discord'
//   auth_user_id            string  (generated on first login, never changes)
//   auth_callsign           string?
//   auth_email              string?
//   auth_discord_id         string?
//   auth_discord_username   string?
//   auth_has_used_app       bool    (ever used app login on this device)
//   auth_has_used_discord   bool    (ever used Discord login on this device)
//   auth_delivery_pref      'app' | 'discord' | absent (not yet chosen)

class AuthService {
  // Keys
  static const _kLoggedIn        = 'auth_is_logged_in';
  static const _kLoginMethod     = 'auth_login_method';
  static const _kUserId          = 'auth_user_id';
  static const _kCallsign        = 'auth_callsign';
  static const _kEmail           = 'auth_email';
  static const _kDiscordId       = 'auth_discord_id';
  static const _kDiscordUsername = 'auth_discord_username';
  static const _kDiscordAvatar  = 'auth_discord_avatar';
  static const _kHasUsedApp      = 'auth_has_used_app';
  static const _kHasUsedDiscord  = 'auth_has_used_discord';
  static const _kDeliveryPref    = 'auth_delivery_pref';

  // In-memory cache (populated by init())
  static SharedPreferences? _prefs;
  static UserRecord? _user;
  static LoginMethod? _loginMethod;
  static DeliveryPreference? _deliveryPref;
  static bool _loggedIn = false;

  // ── Initialisation ──────────────────────────────────────────────────────────

  /// Call once at app startup before accessing any other method.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final p = _prefs!;
    _loggedIn     = p.getBool(_kLoggedIn) ?? false;
    _loginMethod  = _parseMethod(p.getString(_kLoginMethod));
    _deliveryPref = _parsePref(p.getString(_kDeliveryPref));

    if (_loggedIn) {
      _user = UserRecord(
        userId:          p.getString(_kUserId) ?? _generateId(),
        callsign:        p.getString(_kCallsign),
        email:           p.getString(_kEmail),
        discordId:       p.getString(_kDiscordId),
        discordUsername: p.getString(_kDiscordUsername),
        discordAvatar:   p.getString(_kDiscordAvatar),
      );
    }
  }

  // ── Getters ─────────────────────────────────────────────────────────────────

  static bool                get isLoggedIn        => _loggedIn;
  static UserRecord?         get currentUser       => _user;
  static LoginMethod?        get activeLoginMethod => _loginMethod;
  static DeliveryPreference? get deliveryPreference => _deliveryPref;

  static String? get userId        => _user?.userId;
  static String? get discordId     => _user?.discordId;

  /// True when both methods have been used AND delivery preference hasn't been
  /// chosen yet — triggers the "which do you prefer?" prompt.
  static bool get needsDeliveryPreferencePrompt {
    final p = _prefs;
    if (p == null) return false;
    final hasApp     = p.getBool(_kHasUsedApp)     ?? false;
    final hasDiscord = p.getBool(_kHasUsedDiscord) ?? false;
    return hasApp && hasDiscord && _deliveryPref == null;
  }

  // ── App login ────────────────────────────────────────────────────────────────

  /// Records an app login.  Callsign/email validation happens in the UI.
  static Future<void> loginWithApp({
    required String callsign,
    String? email,
  }) async {
    final p      = _prefs!;
    final userId = p.getString(_kUserId) ?? _generateId();

    await Future.wait([
      p.setBool  (_kLoggedIn,    true),
      p.setString(_kLoginMethod, 'app'),
      p.setString(_kUserId,      userId),
      p.setString(_kCallsign,    callsign),
      if (email != null) p.setString(_kEmail, email),
      p.setBool  (_kHasUsedApp,  true),
    ]);

    _loggedIn    = true;
    _loginMethod = LoginMethod.app;
    _user = UserRecord(
      userId:          userId,
      callsign:        callsign,
      email:           email,
      discordId:       p.getString(_kDiscordId),
      discordUsername: p.getString(_kDiscordUsername),
      discordAvatar:   p.getString(_kDiscordAvatar),
    );

    // Default delivery to app when this is the only method used so far.
    if (_deliveryPref == null && !(p.getBool(_kHasUsedDiscord) ?? false)) {
      await _setDeliveryPreferenceInternal(DeliveryPreference.app);
    }
  }

  // ── Discord login ────────────────────────────────────────────────────────────

  /// Records a Discord login after the OAuth flow completes.
  /// [discordId] and [discordUsername] come from the Discord OAuth user object.
  static Future<void> loginWithDiscord({
    required String discordId,
    required String discordUsername,
    String? discordAvatar,
  }) async {
    final p      = _prefs!;
    final userId = p.getString(_kUserId) ?? _generateId();

    await Future.wait([
      p.setBool  (_kLoggedIn,        true),
      p.setString(_kLoginMethod,     'discord'),
      p.setString(_kUserId,          userId),
      p.setString(_kDiscordId,       discordId),
      p.setString(_kDiscordUsername, discordUsername),
      if (discordAvatar != null) p.setString(_kDiscordAvatar, discordAvatar),
      p.setBool  (_kHasUsedDiscord,  true),
    ]);

    _loggedIn    = true;
    _loginMethod = LoginMethod.discord;
    _user = UserRecord(
      userId:          userId,
      callsign:        p.getString(_kCallsign),
      email:           p.getString(_kEmail),
      discordId:       discordId,
      discordUsername: discordUsername,
      discordAvatar:   discordAvatar,
    );

    // Default delivery to discord when this is the only method used so far.
    if (_deliveryPref == null && !(p.getBool(_kHasUsedApp) ?? false)) {
      await _setDeliveryPreferenceInternal(DeliveryPreference.discord);
    }
  }

  // ── Delivery preference ──────────────────────────────────────────────────────

  static Future<void> setDeliveryPreference(DeliveryPreference pref) async {
    await _setDeliveryPreferenceInternal(pref);
  }

  static Future<void> _setDeliveryPreferenceInternal(
      DeliveryPreference pref) async {
    await _prefs!.setString(_kDeliveryPref, pref == DeliveryPreference.app ? 'app' : 'discord');
    _deliveryPref = pref;
  }

  // ── Logout ───────────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    // Preserve has-used flags and userId so they persist across logout/re-login.
    final p      = _prefs!;
    final userId = p.getString(_kUserId);
    await p.clear();
    if (userId != null) await p.setString(_kUserId, userId);

    _loggedIn    = false;
    _loginMethod = null;
    _user        = null;
    // Keep _deliveryPref in memory? No — clear it so re-login picks up fresh state.
    _deliveryPref = null;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  static String _generateId() {
    final rand = Random.secure();
    final bytes = List<int>.generate(8, (_) => rand.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static LoginMethod? _parseMethod(String? s) {
    if (s == 'app')     return LoginMethod.app;
    if (s == 'discord') return LoginMethod.discord;
    return null;
  }

  static DeliveryPreference? _parsePref(String? s) {
    if (s == 'app')     return DeliveryPreference.app;
    if (s == 'discord') return DeliveryPreference.discord;
    return null;
  }
}
