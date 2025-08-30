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
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Create particles
    for (int i = 0; i < 50; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * 400,
          y: _random.nextDouble() * 800,
          size: _random.nextDouble() * 3 + 1,
          speed: _random.nextDouble() * 0.5 + 0.1,
          opacity: _random.nextDouble() * 0.5 + 0.1,
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
          colors: [Colors.blue[900]!, Colors.purple[900]!, Colors.indigo[900]!],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient overlay
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withValues(
                        alpha:
                            0.3 +
                            0.2 *
                                math.sin(
                                  _gradientController.value * 2 * math.pi,
                                ),
                      ),
                      Colors.purple.withValues(
                        alpha:
                            0.3 +
                            0.2 *
                                math.cos(
                                  _gradientController.value * 2 * math.pi,
                                ),
                      ),
                      Colors.indigo.withValues(
                        alpha:
                            0.3 +
                            0.2 *
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

          // Floating particles
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

          // Subtle noise overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    for (final particle in particles) {
      particle.update(animation.value);

      paint.color = Colors.white.withValues(alpha: particle.opacity);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
