import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_colors.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _logoAnim;
  late final Animation<double> _logoFloat;

  @override
  void initState() {
    super.initState();
    _logoAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _logoFloat = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _logoAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _logoAnim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    final state = ref.read(authNotifierProvider);
    if (state is AuthAuthenticated) {
      context.go('/home');
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: const Color(0xFF2A0A0A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: BrandColors.bgDark,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────
          const _BgGradient(),

          // ── Blobs décoratifs ─────────────────────────────────────────
          const Positioned(
            top: -120,
            right: -80,
            child: _Blob(
              size: 340,
              color: BrandColors.blobPrimary,
              delay: Duration.zero,
            ),
          ),
          const Positioned(
            bottom: -100,
            left: -60,
            child: _Blob(
              size: 260,
              color: BrandColors.blobSecondary,
              delay: Duration(seconds: 2),
            ),
          ),

          // ── Contenu ───────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: _GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo animé
                        Center(
                          child: AnimatedBuilder(
                            animation: _logoFloat,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(0, _logoFloat.value),
                              child: child,
                            ),
                            child: const _KalyNowLogo(),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Titre
                        const Text(
                          'Bon retour',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Connectez-vous pour accéder à vos offres',
                          style: TextStyle(
                            color: BrandColors.textFaint,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Erreur
                        if (authState is AuthError) ...[
                          _ErrorBanner(message: authState.message),
                          const SizedBox(height: 20),
                        ],

                        // Champ email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Adresse email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Veuillez saisir votre email.';
                            }
                            if (!v.contains('@')) {
                              return 'Email invalide.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Champ mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          style: const TextStyle(color: Colors.white),
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: BrandColors.iconColor,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Veuillez saisir votre mot de passe.';
                            }
                            if (v.length < 6) {
                              return 'Minimum 6 caractères.';
                            }
                            return null;
                          },
                        ),

                        // Mot de passe oublié
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Mot de passe oublié ?'),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Bouton connexion
                        _GradientButton(
                          onPressed: isLoading ? null : _submit,
                          isLoading: isLoading,
                          label: 'Se connecter',
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(color: BrandColors.glassBorder),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ou',
                                style: TextStyle(
                                  color: BrandColors.textFaint,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: BrandColors.glassBorder),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Bouton Google (à connecter ultérieurement)
                        const _GoogleButton(),
                        const SizedBox(height: 24),

                        // Lien inscription
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Pas encore de compte ? ',
                              style: TextStyle(
                                color: BrandColors.textFaint,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text(
                                'Créer un compte',
                                style: TextStyle(
                                  color: BrandColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sous-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _BgGradient extends StatelessWidget {
  const _BgGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: BrandColors.bgGradient),
    );
  }
}

class _Blob extends StatefulWidget {
  const _Blob({
    required this.size,
    required this.color,
    required this.delay,
  });

  final double size;
  final Color color;
  final Duration delay;

  @override
  State<_Blob> createState() => _BlobState();
}

class _BlobState extends State<_Blob> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13), // ~0.05 opacity
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: BrandColors.glassBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: child,
        ),
      ),
    );
  }
}

class _KalyNowLogo extends StatelessWidget {
  const _KalyNowLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icône stylisée — flamme / feuille kalyNow
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            gradient: BrandColors.gradientBtn,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.eco_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [BrandColors.secondary, BrandColors.primary],
          ).createShader(bounds),
          child: const Text(
            'KalyNow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x26FF5252),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DFF5252)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF8A80),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFFF8A80),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? const LinearGradient(
                  colors: [Color(0x4DC75B12), Color(0x4DE07830)],
                )
              : BrandColors.gradientBtn,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: BrandColors.primary.withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Disponible prochainement',
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.glassBorder),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            // TODO: connecter Google Sign-In
            onTap: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône Google en SVG-like via CustomPaint
                _GoogleIcon(),
                const SizedBox(width: 12),
                const Text(
                  'Continuer avec Google',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Cercle de base
    final bgPaint = Paint()..color = Colors.white.withAlpha(200);
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Lettre "G" simplifiée via arcs colorés
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72);

    final colors = [
      const Color(0xFF4285F4), // bleu
      const Color(0xFF34A853), // vert
      const Color(0xFFFBBC05), // jaune
      const Color(0xFFEA4335), // rouge
    ];

    final sweeps = [90.0, 90.0, 90.0, 90.0];
    final starts = [-180.0, -90.0, 0.0, 90.0];

    for (int i = 0; i < 4; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.2
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        starts[i] * 3.14159 / 180,
        sweeps[i] * 3.14159 / 180,
        false,
        paint,
      );
    }

    // Barre horizontale droite du G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.72, cy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
