import 'package:flutter/material.dart';

const _lime = Color(0xFFA6FF2E);

/// Military-style text field used across login and sign-up screens.
class TacField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType? keyboard;
  final bool obscure;

  const TacField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.icon,
    this.keyboard,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: _lime.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF070E07),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: _lime.withValues(alpha: 0.20)),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboard,
            obscureText: obscure,
            style: const TextStyle(
                color: Color(0xFFCCCCCC), fontSize: 14, letterSpacing: 0.5),
            cursorColor: _lime,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
              suffixIcon:
                  Icon(icon, color: _lime.withValues(alpha: 0.35), size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
