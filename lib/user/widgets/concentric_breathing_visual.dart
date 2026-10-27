import 'package:flutter/material.dart';

/// Concentric breathing rings visual matching the exact reference screenshot:
/// - 3 translucent outer mint ripple rings
/// - Solid deep emerald core with white leaf emblem
/// - Smooth pulse animation when active/breathing
class ConcentricBreathingVisual extends StatelessWidget {
  final double size;
  final double scale;
  final bool showShadow;

  const ConcentricBreathingVisual({
    super.key,
    this.size = 148,
    this.scale = 1.0,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 1 (Outermost Pale Mint Ripple)
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const color(0xFFC7E8DC).withAlpha(140),
                ),
              ),

              // Ring 2 (Middle Mint Ripple)
              Container(
                width: size * 0.78,
                height: size * 0.78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const color(0xFFA3D9C4).withAlpha(170),
                ),
              ),

              // Ring 3 (Inner Mint Ripple)
              Container(
                width: size * 0.58,
                height: size * 0.58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const color(0xFF67B799).withAlpha(190),
                ),
              ),

              // Core Emerald Circle
              Container(
                width: size * 0.40,
                height: size * 0.40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const color(0xFF165A47),
                  boxShadow: showShadow
                      ? [
                          BoxShadow(
                            color: const color(0xFF165A47).withAlpha(60),
                            blurRadius: 14,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    Icons.eco_rounded,
                    color: colors.white,
                    size: size * 0.22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

