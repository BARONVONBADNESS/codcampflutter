import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

// ── Configuration ───────────────────────────────────────────────────────────
//
// Fill these in after creating your Discord application at:
//   https://discord.com/developers/applications
//
// 1. Create a new application → copy the CLIENT ID
// 2. Go to OAuth2 → add redirect URIs for each platform:
//      Web:    https://YOUR_DOMAIN/auth/discord/callback
//      Mobile: codcamp://auth
// 3. Copy the CLIENT SECRET → put it in your backend .env ONLY (never ship it)

class DiscordOAuthConfig {
  /// Your Discord application's client ID (safe to embed in the app).
  static const clientId = '1494294660133290095';

  /// The URL of YOUR backend that handles the code → token exchange.
  /// This endpoint receives ?code=... from Discord, exchanges it for a token,
  /// fetches the Discord user, and redirects to the app with the user info.
  ///
  /// For web builds it should redirect back to [webRedirectUri].
  /// For mobile builds it should redirect to [mobileRedirectUri].
  static const backendCallbackUrl =
      'https://codcampflutter.onrender.com/auth/discord/callback';

  /// Where Discord redirects after the user authorizes (must match OAuth2 settings).
  /// On web this is your app's URL; on mobile it's the custom scheme.
  static const webRedirectUri =
      'https://codcampflutter.onrender.com/auth/discord/callback';
  static const mobileRedirectUri = 'codcamp://auth';

  /// OAuth2 scopes — 'identify' gives us user ID + username.
  static const scopes = 'identify';

  /// Discord API endpoints.
  static const authorizeUrl = 'https://discord.com/api/oauth2/authorize';
  static const tokenUrl     = 'https://discord.com/api/oauth2/token';
  static const userUrl      = 'https://discord.com/api/users/@me';

  /// Returns the redirect URI appropriate for the current platform.
  static String get redirectUri =>
      kIsWeb ? webRedirectUri : mobileRedirectUri;

  /// Builds the full Discord OAuth2 authorization URL.
  static Uri buildAuthorizeUri({String? state}) {
    return Uri.parse(authorizeUrl).replace(queryParameters: {
      'client_id':     clientId,
      'redirect_uri':  redirectUri,
      'response_type': 'code',
      'scope':         scopes,
      if (state != null) 'state': state,
    });
  }
}

// ── OAuth result ────────────────────────────────────────────────────────────

class DiscordUser {
  final String id;
  final String username;
  final String? globalName;
  final String? avatar;

  const DiscordUser({
    required this.id,
    required this.username,
    this.globalName,
    this.avatar,
  });

  factory DiscordUser.fromJson(Map<String, dynamic> json) {
    return DiscordUser(
      id:         json['id'] as String,
      username:   json['username'] as String,
      globalName: json['global_name'] as String?,
      avatar:     json['avatar'] as String?,
    );
  }

  /// Display name — global name if set, otherwise username.
  String get displayName => globalName ?? username;
}

// ── Discord OAuth Service ───────────────────────────────────────────────────

class DiscordOAuthService {
  static AppLinks? _appLinks;
  static StreamSubscription? _linkSub;
  static Completer<DiscordUser?>? _authCompleter;

  /// Initialise deep link listener. Call once from main() BEFORE runApp().
  static void init() {
    if (kIsWeb) return; // Web handles redirects via URL query params
    _appLinks = AppLinks();
    _linkSub = _appLinks!.uriLinkStream.listen(_handleIncomingLink);
  }

  /// Dispose the listener (call on app shutdown if needed).
  static void dispose() {
    _linkSub?.cancel();
    _linkSub = null;
  }

  // ── Public API ──────────────────────────────────────────────────────────

  /// Launches the Discord OAuth flow and returns the authenticated user,
  /// or null if the user cancelled / an error occurred.
  static Future<DiscordUser?> authenticate() async {
    _authCompleter = Completer<DiscordUser?>();

    // On web, pass our origin in the state param so the backend knows
    // to redirect back here (instead of codcamp:// which browsers can't handle).
    final webOrigin = kIsWeb ? Uri.base.origin : null;
    final uri = DiscordOAuthConfig.buildAuthorizeUri(
      state: kIsWeb ? 'web:$webOrigin' : null,
    );

    if (kIsWeb) {
      // On web: open Discord auth. After authorization, Discord redirects to
      // the backend, which exchanges the code and redirects back to our web
      // origin with ?discord_id=...&username=... in the URL.
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      // On mobile: open Discord in the system browser.
      // The deep link (codcamp://auth?...) fires _handleIncomingLink().
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _authCompleter?.complete(null);
        _authCompleter = null;
        return null;
      }
    }

    // Wait for the deep link / redirect callback to resolve.
    return _authCompleter?.future;
  }

  /// Call from main() on web when the page loads with ?code=... in the URL.
  static Future<void> handleWebRedirect(Uri uri) async {
    await _handleIncomingLink(uri);
  }

  // ── Internal ────────────────────────────────────────────────────────────

  static Future<void> _handleIncomingLink(Uri uri) async {
    // We expect either:
    //   codcamp://auth?discord_id=...&username=...   (from our backend)
    //   codcamp://auth?code=...                       (raw code, exchange here)
    //   https://our-domain/...?code=...               (web redirect)

    final discordId = uri.queryParameters['discord_id'];
    final username  = uri.queryParameters['username'];

    if (discordId != null && username != null) {
      // Backend already did the exchange and sent us user info directly.
      final user = DiscordUser(
        id: discordId,
        username: username,
        globalName: uri.queryParameters['global_name'],
      );
      _authCompleter?.complete(user);
      _authCompleter = null;
      return;
    }

    final code = uri.queryParameters['code'];
    if (code != null) {
      // We have a raw authorization code — send it to our backend for exchange.
      try {
        final user = await _exchangeCodeViaBackend(code);
        _authCompleter?.complete(user);
      } catch (e) {
        _authCompleter?.complete(null);
      }
      _authCompleter = null;
      return;
    }

    // Error or user cancelled
    final error = uri.queryParameters['error'];
    if (error != null) {
      _authCompleter?.complete(null);
      _authCompleter = null;
    }
  }

  /// Sends the authorization code to our backend, which exchanges it for a
  /// token and returns the Discord user info as JSON.
  static Future<DiscordUser?> _exchangeCodeViaBackend(String code) async {
    final response = await http.post(
      Uri.parse('${DiscordOAuthConfig.backendCallbackUrl}/exchange'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'redirect_uri': DiscordOAuthConfig.redirectUri,
      }),
    );

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return DiscordUser.fromJson(json);
  }
}
