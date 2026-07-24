import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../services/tips_service.dart';
import '../services/discord_oauth.dart';
import '../shared/widgets/tac_field.dart';

const _lime    = Color(0xFFA6FF2E);
const _bg      = Color(0xFF050A05);
const _discord = Color(0xFF5865F2);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _callsignCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();

  late final AnimationController _pulse;

  bool _ageVerified  = false;
  bool _tosAccepted  = false;
  bool _submitting   = false;
  String? _errorMsg;
  String? _successMsg;

  // Discord link (optional)
  String? _discordId;
  String? _discordUsername;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1700))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _callsignCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _linkDiscord() async {
    try {
      final discordUser = await DiscordOAuthService.authenticate();
      if (!mounted) return;
      if (discordUser != null) {
        setState(() {
          _discordId = discordUser.id;
          _discordUsername = discordUser.username;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMsg = 'Discord link failed: $e');
      }
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final callsign = _callsignCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm  = _confirmCtrl.text.trim();

    if (callsign.length < 3) {
      setState(() => _errorMsg = 'Callsign must be at least 3 characters.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorMsg = 'Enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMsg = 'Password must be at least 6 characters.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMsg = 'Passwords do not match.');
      return;
    }
    if (!_ageVerified) {
      setState(() => _errorMsg = 'You must confirm you are 13 or older.');
      return;
    }
    if (!_tosAccepted) {
      setState(() => _errorMsg = 'You must accept the Terms of Service.');
      return;
    }

    setState(() { _submitting = true; _errorMsg = null; });
    HapticFeedback.mediumImpact();

    try {
      final response = await http
          .post(
            Uri.parse('$kTipsBaseUrl/api/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'callsign':    callsign,
              'email':       email,
              'password':    password,
              'discordId':   _discordId,
              'ageVerified': _ageVerified,
              'tosAccepted': _tosAccepted,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        setState(() {
          _submitting = false;
          _successMsg = data['message'] as String? ??
              'Account created! Awaiting review.';
        });
      } else {
        setState(() {
          _submitting = false;
          _errorMsg = data['error'] as String? ?? 'Sign-up failed.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMsg = 'Could not reach server. Is the engine running?';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(children: [
                  Icon(Icons.chevron_left_rounded,
                      color: _lime.withValues(alpha: 0.55), size: 20),
                  const SizedBox(width: 4),
                  Text('BACK TO LOGIN',
                      style: TextStyle(
                          color: _lime.withValues(alpha: 0.55),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5)),
                ]),
              ),

              const SizedBox(height: 24),

              // Header
              Text('NEW RECRUIT',
                  style: TextStyle(
                      color: _lime.withValues(alpha: 0.50),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4.0)),
              const SizedBox(height: 4),
              const Text('ENLIST',
                  style: TextStyle(
                      color: _lime,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5.0,
                      height: 1.0)),

              const SizedBox(height: 28),

              // Success state
              if (_successMsg != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _lime.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: _lime.withValues(alpha: 0.30)),
                  ),
                  child: Column(children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: _lime, size: 48),
                    const SizedBox(height: 14),
                    Text('ENLISTMENT SUBMITTED',
                        style: TextStyle(
                            color: _lime,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0)),
                    const SizedBox(height: 10),
                    Text(_successMsg!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12,
                            height: 1.5)),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: _lime.withValues(alpha: 0.45)),
                        ),
                        child: const Text('RETURN TO LOGIN',
                            style: TextStyle(
                                color: _lime,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0)),
                      ),
                    ),
                  ]),
                ),
              ] else ...[

                // Form fields
                TacField(
                  ctrl: _callsignCtrl,
                  label: 'CALLSIGN',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),

                TacField(
                  ctrl: _emailCtrl,
                  label: 'EMAIL',
                  icon: Icons.email_outlined,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                TacField(
                  ctrl: _passwordCtrl,
                  label: 'PASSWORD',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                ),
                const SizedBox(height: 12),

                TacField(
                  ctrl: _confirmCtrl,
                  label: 'CONFIRM PASSWORD',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                ),

                const SizedBox(height: 20),

                // Discord link (optional)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _discord.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: _discord.withValues(alpha: 0.18)),
                  ),
                  child: _discordId != null
                      ? Row(children: [
                          const Icon(Icons.discord,
                              color: _discord, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                'LINKED: $_discordUsername',
                                style: const TextStyle(
                                    color: _discord,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5)),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              _discordId = null;
                              _discordUsername = null;
                            }),
                            child: Text('REMOVE',
                                style: TextStyle(
                                    color: _discord.withValues(alpha: 0.55),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ])
                      : GestureDetector(
                          onTap: _linkDiscord,
                          child: Row(children: [
                            const Icon(Icons.discord,
                                color: _discord, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text('LINK DISCORD ACCOUNT',
                                      style: TextStyle(
                                          color: _discord,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5)),
                                  const SizedBox(height: 2),
                                  Text(
                                      'Required — must be a member of the Ghost Protocol server',
                                      style: TextStyle(
                                          color: _discord
                                              .withValues(alpha: 0.45),
                                          fontSize: 9)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: _discord.withValues(alpha: 0.40),
                                size: 18),
                          ]),
                        ),
                ),

                const SizedBox(height: 18),

                // Age verification checkbox
                _TacCheck(
                  value: _ageVerified,
                  label: 'I confirm I am 13 years of age or older',
                  onChanged: (v) =>
                      setState(() => _ageVerified = v ?? false),
                ),
                const SizedBox(height: 10),

                // ToS acceptance checkbox
                _TacCheck(
                  value: _tosAccepted,
                  label:
                      'I accept the Terms of Service and Privacy Policy',
                  onChanged: (v) =>
                      setState(() => _tosAccepted = v ?? false),
                ),

                // Error
                if (_errorMsg != null) ...[
                  const SizedBox(height: 14),
                  Text(_errorMsg!,
                      style: const TextStyle(
                          color: Color(0xFFFF6B6B), fontSize: 11)),
                ],

                const SizedBox(height: 24),

                // Submit button
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, _) => GestureDetector(
                    onTap: _submitting ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: const Color(0xFF0A1805),
                        border: Border.all(
                            color: _lime.withValues(
                                alpha: _submitting
                                    ? 0.20
                                    : 0.55 + _pulse.value * 0.40),
                            width: 1.5),
                        boxShadow: _submitting
                            ? null
                            : [
                                BoxShadow(
                                    color: _lime.withValues(
                                        alpha:
                                            0.07 + _pulse.value * 0.14),
                                    blurRadius:
                                        18 + _pulse.value * 10,
                                    spreadRadius: 1),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              _submitting ? 'ENLISTING...' : 'ENLIST',
                              style: TextStyle(
                                  color: _submitting
                                      ? _lime.withValues(alpha: 0.35)
                                      : _lime,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6.0)),
                          if (!_submitting) ...[
                            const SizedBox(width: 10),
                            Icon(Icons.chevron_right_rounded,
                                color: _lime.withValues(
                                    alpha:
                                        0.65 + _pulse.value * 0.35),
                                size: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tactical checkbox ────────────────────────────────────────────────────────

class _TacCheck extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;

  const _TacCheck({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: value
                  ? _lime.withValues(alpha: 0.12)
                  : const Color(0xFF070E07),
              border: Border.all(
                  color: value
                      ? _lime.withValues(alpha: 0.55)
                      : _lime.withValues(alpha: 0.18)),
            ),
            child: value
                ? const Icon(Icons.check_rounded, color: _lime, size: 14)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.50),
                    fontSize: 12,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}
