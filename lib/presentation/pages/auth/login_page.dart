import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _pulseController;
  String? _loadingProvider;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loginWith(String provider) async {
    setState(() => _loadingProvider = provider);
    HapticFeedback.lightImpact();
    try {
      switch (provider) {
        case 'discord':
          await ref.read(authProvider.notifier).loginWithDiscord();
          break;
        case 'google':
          await ref.read(authProvider.notifier).loginWithGoogle();
          break;
        case 'apple':
          await ref.read(authProvider.notifier).loginWithApple();
          break;
        case 'github':
          await ref.read(authProvider.notifier).loginWithGitHub();
          break;
        case 'biometric':
          await ref.read(authProvider.notifier).loginWithBiometric();
          break;
      }
    } finally {
      if (mounted) setState(() => _loadingProvider = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true; // Login always uses dark theme

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _BgPainter(_bgController.value),
            ),
          ),

          // Glowing orbs
          Positioned(
            top: -100,
            left: -80,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.discordBlurple.withOpacity(
                        0.18 + 0.06 * _pulseController.value),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.discordFuchsia.withOpacity(
                        0.14 + 0.06 * _pulseController.value),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 64),

                  // Logo & Title
                  _buildHeader()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: -0.3, curve: Curves.easeOut),

                  const SizedBox(height: 52),

                  // Login Card
                  _buildLoginCard()
                      .animate()
                      .fadeIn(delay: 450.ms, duration: 700.ms)
                      .slideY(begin: 0.4, curve: Curves.easeOut),

                  const SizedBox(height: 28),

                  // Footer
                  Text(
                    'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: Colors.white.withOpacity(0.35),
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 500.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (_, child) => Transform.scale(
            scale: 1.0 + _pulseController.value * 0.03,
            child: child,
          ),
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.discordBlurple.withOpacity(0.55),
                  blurRadius: 36,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Discord Bot Manager',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your Discord bot from anywhere',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FeaturePill(
              icon: Icons.shield_outlined,
              label: 'Secure',
              color: AppColors.discordGreen,
            ),
            const SizedBox(width: 8),
            _FeaturePill(
              icon: Icons.bolt_outlined,
              label: 'Real-time',
              color: AppColors.discordYellow,
            ),
            const SizedBox(width: 8),
            _FeaturePill(
              icon: Icons.tune_outlined,
              label: 'Full Control',
              color: AppColors.discordBlurple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.13),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Sign in to manage your bot',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 28),

              // Discord - Primary
              GradientButton(
                label: 'Continue with Discord',
                gradient: AppColors.primaryGradient,
                icon: Icons.discord,
                isLoading: _loadingProvider == 'discord',
                onPressed: () => _loginWith('discord'),
              ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.2),

              const SizedBox(height: 12),

              // Google
              _SocialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: const Color(0xFFDB4437),
                isLoading: _loadingProvider == 'google',
                onTap: () => _loginWith('google'),
              ).animate(delay: 700.ms).fadeIn().slideX(begin: -0.2),

              const SizedBox(height: 12),

              // Apple
              _SocialButton(
                label: 'Continue with Apple',
                icon: Icons.apple_rounded,
                iconColor: Colors.white,
                isLoading: _loadingProvider == 'apple',
                onTap: () => _loginWith('apple'),
              ).animate(delay: 800.ms).fadeIn().slideX(begin: -0.2),

              const SizedBox(height: 12),

              // GitHub
              _SocialButton(
                label: 'Continue with GitHub',
                icon: Icons.code_rounded,
                iconColor: Colors.white,
                isLoading: _loadingProvider == 'github',
                onTap: () => _loginWith('github'),
              ).animate(delay: 900.ms).fadeIn().slideX(begin: -0.2),

              const SizedBox(height: 22),

              Row(children: [
                Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'Quick Access',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
              ]),

              const SizedBox(height: 18),

              // Biometric
              GestureDetector(
                onTap: () => _loginWith('biometric'),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.discordBlurple.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_loadingProvider == 'biometric')
                        const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.discordBlurple,
                          ),
                        )
                      else ...[
                        const Icon(
                          Icons.fingerprint_rounded,
                          color: AppColors.discordBlurple,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Use Biometric Login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.discordBlurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ).animate(delay: 1000.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  static final _rng = math.Random(123);
  static final _particles = List.generate(
    60,
    (i) => [
      _rng.nextDouble(), // x
      _rng.nextDouble(), // y
      _rng.nextDouble() * 2.5 + 0.5, // size
      _rng.nextDouble() * 0.4 + 0.05, // speed
      _rng.nextDouble() * 0.45 + 0.05, // opacity
      i % 4, // color index
    ],
  );
  static const _colors = [
    Color(0xFF5865F2),
    Color(0xFFEB459E),
    Color(0xFF57F287),
    Colors.white,
  ];

  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0D1117), Color(0xFF1A1D2E), Color(0xFF16213E)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Particles
    for (final p in _particles) {
      final y = (p[1] + t * p[3]) % 1.0;
      final paint = Paint()
        ..color = _colors[p[5].toInt()].withOpacity(p[4])
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p[0] * size.width, y * size.height),
        p[2],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t;
}
