import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    // Create speech therapy themed particles (speech bubbles, stars, etc.)
    for (int i = 0; i < 40; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * 400,
          y: _random.nextDouble() * 800,
          size: _random.nextDouble() * 4 + 2,
          speed: _random.nextDouble() * 0.3 + 0.05,
          opacity: _random.nextDouble() * 0.4 + 0.1,
          type: _random.nextBool() ? ParticleType.speechBubble : ParticleType.star,
        ),
      );
    }

    _particleController.repeat();
    _gradientController.repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE0F2FE), // Light blue
            const Color(0xFFF3E8FF), // Light purple
            const Color(0xFFFEF3C7), // Light yellow
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient overlay with child-friendly colors
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6B73FF).withValues(
                        alpha:
                            0.1 +
                            0.08 *
                                math.sin(
                                  _gradientController.value * 2 * math.pi,
                                ),
                      ),
                      const Color(0xFF8B5CF6).withValues(
                        alpha:
                            0.1 +
                            0.08 *
                                math.cos(
                                  _gradientController.value * 2 * math.pi,
                                ),
                      ),
                      const Color(0xFF10B981).withValues(
                        alpha:
                            0.1 +
                            0.08 *
                                math.sin(
                                  _gradientController.value * 2 * math.pi +
                                      math.pi / 2,
                                ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating speech therapy themed particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ParticlePainter(
                  particles: _particles,
                  animation: _particleController,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Subtle texture overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
            ),
          ),
        ],
      ),
    );
  }
}

enum ParticleType { speechBubble, star }

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final ParticleType type;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.type,
  });

  void update(double deltaTime) {
    y -= speed * deltaTime;
    if (y < -50) {
      y = 850;
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Animation<double> animation;

  _ParticlePainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update(animation.value);

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = particle.type == ParticleType.speechBubble
            ? const Color(0xFF6B73FF).withValues(alpha: particle.opacity)
            : const Color(0xFFF59E0B).withValues(alpha: particle.opacity);

      if (particle.type == ParticleType.speechBubble) {
        _drawSpeechBubble(canvas, Offset(particle.x, particle.y), particle.size, paint);
      } else {
        _drawStar(canvas, Offset(particle.x, particle.y), particle.size, paint);
      }
    }
  }

  void _drawSpeechBubble(Canvas canvas, Offset center, double size, Paint paint) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size * 2, height: size * 1.5),
      Radius.circular(size * 0.3),
    );
    canvas.drawRRect(rect, paint);
    
    // Draw speech bubble tail
    final path = Path();
    path.moveTo(center.dx - size * 0.3, center.dy + size * 0.75);
    path.lineTo(center.dx - size * 0.6, center.dy + size * 1.2);
    path.lineTo(center.dx + size * 0.1, center.dy + size * 0.75);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * math.pi / 5 - math.pi / 2;
      final outerRadius = size;
      final innerRadius = size * 0.4;
      
      final outerPoint = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + innerRadius * math.cos(angle + math.pi / 5),
        center.dy + innerRadius * math.sin(angle + math.pi / 5),
      );
      
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
