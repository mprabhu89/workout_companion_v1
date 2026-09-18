import 'package:flutter/material.dart';

const ritmoCyan = Color(0xFF68E7F4);
const ritmoOrange = Color(0xFFFFA64D);

/// Keeps form controls visually aligned with the shared RITMO HUD panels.
InputDecoration ritmoCoreHudInputDecoration({String? label, String? hint}) {
  const border = OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF31535C)),
  );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(
      color: Color(0xFF9FC7CE),
      fontWeight: FontWeight.w800,
      letterSpacing: 0.7,
    ),
    hintStyle: const TextStyle(color: Color(0xFF78969D)),
    filled: true,
    fillColor: const Color(0xFF0B171C),
    enabledBorder: border,
    border: border,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ritmoCyan, width: 1.3),
    ),
  );
}

/// Reusable near-black game HUD treatment for RITMO presentation screens.
class RitmoCyberpunkBackground extends StatelessWidget {
  const RitmoCyberpunkBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF05090C),
        gradient: RadialGradient(
          center: Alignment(-0.8, -0.9),
          radius: 1.2,
          colors: [Color(0xFF10313A), Color(0xFF05090C)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -90,
            right: -70,
            child: _GlowOrb(color: ritmoCyan, size: 230),
          ),
          const Positioned(
            bottom: 70,
            left: -110,
            child: _GlowOrb(color: ritmoOrange, size: 200),
          ),
          child,
        ],
      ),
    );
  }
}

class RitmoHudPanel extends StatelessWidget {
  const RitmoHudPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.glowStrength = 0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double glowStrength;

  @override
  Widget build(BuildContext context) {
    final strength = glowStrength.clamp(0.0, 1.0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        boxShadow: strength > 0
            ? [
                BoxShadow(
                  color: ritmoCyan.withValues(alpha: 0.08 + (0.22 * strength)),
                  blurRadius: 12 + (18 * strength),
                  spreadRadius: strength,
                ),
              ]
            : const [],
      ),
      child: CustomPaint(
        foregroundPainter: _HudFramePainter(
          color: Color.lerp(const Color(0xFF31535C), ritmoCyan, strength)!,
        ),
        child: ClipPath(
          clipper: const _HudCutCornerClipper(),
          child: Container(
            padding: padding,
            color: const Color(0xEF101B20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class RitmoHudSectionHeading extends StatelessWidget {
  const RitmoHudSectionHeading({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 22, color: ritmoCyan),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class RitmoActionButton extends StatelessWidget {
  const RitmoActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPulsing = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPulsing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: isPulsing ? 1.035 : 1,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ClipPath(
            clipper: const _HudCutCornerClipper(cutSize: 9),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                splashColor: ritmoOrange.withValues(alpha: 0.28),
                highlightColor: ritmoCyan.withValues(alpha: 0.12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B171C),
                    border: Border.all(
                      color: isPulsing ? ritmoOrange : ritmoCyan,
                      width: 1.3,
                    ),
                    boxShadow: isPulsing
                        ? [
                            BoxShadow(
                              color: ritmoCyan.withValues(alpha: 0.42),
                              blurRadius: 14,
                            ),
                          ]
                        : const [],
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              color: Color(0xFFD4FBFF),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: ritmoCyan),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared modal shell for short confirmations and configuration prompts.
class RitmoHudDialog extends StatelessWidget {
  const RitmoHudDialog({
    super.key,
    required this.title,
    this.actions = const [],
    this.destructive = false,
    required this.child,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final accent = destructive ? const Color(0xFFFF8C8C) : ritmoCyan;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: RitmoHudPanel(
        glowStrength: 0.32,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              child,
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HudFramePainter extends CustomPainter {
  const _HudFramePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const cut = 16.0;
    final path = Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width - cut, 0)
      ..lineTo(size.width, cut)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(cut, size.height)
      ..lineTo(0, size.height - cut)
      ..lineTo(0, cut)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _HudFramePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _HudCutCornerClipper extends CustomClipper<Path> {
  const _HudCutCornerClipper({this.cutSize = 16});

  final double cutSize;

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(cutSize, 0)
      ..lineTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(cutSize, size.height)
      ..lineTo(0, size.height - cutSize)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(covariant _HudCutCornerClipper oldClipper) =>
      oldClipper.cutSize != cutSize;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.16), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
