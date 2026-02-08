import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/flux_logo.dart';
import '../../../auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp;

  const HomePage({
    super.key,
    required this.onGetStarted,
    this.onLogin,
    this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.1),
              AppColors.backgroundLight,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header with Login and Sign Up buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  FluxLogo(height: 60),
                  // Auth buttons
                  Row(
                    children: [
                      _HeaderButton(
                        text: 'Login',
                        onPressed: onLogin ?? onGetStarted,
                        isPrimary: false,
                      ),
                      const SizedBox(width: 12),
                      _HeaderButton(
                        text: 'Sign Up',
                        onPressed: onSignUp ?? onGetStarted,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with name
                  FluxLogo(height: 300),
                  const SizedBox(height: 32),

                  // Tagline
                  Text(
                    'The world\'s best task management',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Organize your tasks, boost your productivity',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 64),

                  // Feature Cards
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _FeatureCard(
                          icon: Icons.calendar_today,
                          title: 'Smart Calendar',
                          description: 'Visualize your tasks on an intuitive calendar',
                        ),
                        _FeatureCard(
                          icon: Icons.color_lens,
                          title: 'Color Coding',
                          description: 'Organize tasks with custom color categories',
                        ),
                        _FeatureCard(
                          icon: Icons.timer_outlined,
                          title: 'Deadlines',
                          description: 'Never miss a deadline with smart reminders',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),

                  // CTA Button
                  _HoverButton(
                    onPressed: onGetStarted,
                    text: 'Get Started',
                    isLarge: true,
                  ),
                  const SizedBox(height: 16),
                      Text(
                        'Start managing your tasks in seconds',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _HeaderButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: widget.isPrimary
            ? ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isHovered
                      ? AppColors.primary.withOpacity(0.9)
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: _isHovered ? 4 : 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : TextButton(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: _isHovered
                      ? AppColors.primary
                      : AppColors.textPrimaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.borderLight,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              widget.icon,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLarge;

  const _HoverButton({
    required this.onPressed,
    required this.text,
    this.isLarge = false,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? AppColors.primary.withOpacity(0.9)
                : AppColors.primary,
            foregroundColor: Colors.white,
            elevation: _isHovered ? 8 : 2,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isLarge ? 48 : 32,
              vertical: widget.isLarge ? 20 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: widget.isLarge ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
