import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';
// NOTE: kalau sudah pakai named route '/dashboard', import dashboard.dart tidak wajib.
// import 'screens/dashboard.dart';

class SplashAnimatedPage extends StatefulWidget {
  const SplashAnimatedPage({super.key});

  @override
  State<SplashAnimatedPage> createState() => _SplashAnimatedPageState();
}

class _SplashAnimatedPageState extends State<SplashAnimatedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _profileFade;
  late final Animation<double> _profileScale;

  @override
  void initState() {
    super.initState();

    _c =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              // PAKAI NAMED ROUTE SESUAI MaterialApp.routes
              Navigator.of(context).pushReplacementNamed('/dashboard');
            }
          })
          ..forward();

    // Staggered
    _titleFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.00, 0.32, curve: Curves.easeOut),
    );
    _titleSlide = Tween(begin: const Offset(0, .25), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.00, 0.32, curve: Curves.easeOut),
      ),
    );
    _profileFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.32, 0.64, curve: Curves.easeOut),
    );
    _profileScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.32, 0.64, curve: Curves.easeOutBack),
      ),
    );

    // Precache aset biar transisi mulus—pastikan file ada di pubspec.yaml
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(const AssetImage('assets/images/bg.png'), context);
      await precacheImage(
        const AssetImage('assets/images/profile.png'),
        context,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.blush,
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value; // 0..1
          final dx = math.sin(2 * math.pi * t) * 12;
          final dy = math.cos(2 * math.pi * t) * 8;

          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.translate(
                offset: Offset(dx, dy),
                child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
              ),
              Container(color: Colors.white.withOpacity(0.20)),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Column(
                            children: [
                              Text(
                                'Listy Verse App',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark.withOpacity(0.90),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'freshly & friendly',
                                style: TextStyle(letterSpacing: 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      FadeTransition(
                        opacity: _profileFade,
                        child: ScaleTransition(
                          scale: _profileScale,
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: w * 0.7,
                                  maxHeight: w * 0.7,
                                ),
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'listy nuri s.',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'NIM: 152022002',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Progress
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _c.value,
                    minHeight: 6,
                    backgroundColor: AppColors.creamy.withOpacity(.6),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
