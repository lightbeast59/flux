import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/theme_provider.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../../core/utils/download_helper.dart' as download_helper;

class SettingsPage extends ConsumerStatefulWidget {
  final VoidCallback? onLogout;

  const SettingsPage({super.key, this.onLogout});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    final authState = ref.watch(authStateProvider);

    return Container(
      color: themeProvider.isDarkMode ? const Color(0xFF0F172A) : AppColors.backgroundLight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 32),

            // Appearance Section
            _buildSectionHeader('Appearance', themeProvider.isDarkMode),
            const SizedBox(height: 16),
            _buildCard(
              themeProvider.isDarkMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dark Mode Toggle
                  _buildSettingRow(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: 'Switch between light and dark theme',
                    isDarkMode: themeProvider.isDarkMode,
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                  ),
                  const Divider(height: 32),
                  // Theme Color
                  Text(
                    'Theme Color',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred accent color',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: themeProvider.isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeProvider.availableColors.map((colorOption) {
                      final isSelected = themeProvider.primaryColor.value == colorOption.color.value;
                      return _ColorOption(
                        color: colorOption.color,
                        name: colorOption.name,
                        isSelected: isSelected,
                        onTap: () {
                          themeProvider.setPrimaryColor(colorOption.color);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Text Size
                  Text(
                    'Text Size',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adjust the text size throughout the app',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: themeProvider.isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeProvider.availableTextSizes.map((sizeOption) {
                      final isSelected = themeProvider.textScaleFactor == sizeOption.scale;
                      return _TextSizeOption(
                        name: sizeOption.name,
                        scale: sizeOption.scale,
                        isSelected: isSelected,
                        primaryColor: themeProvider.primaryColor,
                        onTap: () {
                          themeProvider.setTextScaleFactor(sizeOption.scale);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Background Color
                  Text(
                    'Background Color',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred background color (light mode only)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: themeProvider.isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeProvider.availableBackgroundColors.map((colorOption) {
                      final isSelected = themeProvider.backgroundColor.value == colorOption.color.value;
                      return _BackgroundColorOption(
                        color: colorOption.color,
                        name: colorOption.name,
                        isSelected: isSelected,
                        primaryColor: themeProvider.primaryColor,
                        onTap: () {
                          themeProvider.setBackgroundColor(colorOption.color);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Account Section
            _buildSectionHeader('Account', themeProvider.isDarkMode),
            const SizedBox(height: 16),
            _buildCard(
              themeProvider.isDarkMode,
              child: Column(
                children: [
                  authState.when(
                    data: (user) {
                      if (user != null) {
                        return _buildSettingRow(
                          icon: Icons.person,
                          title: user.displayName ?? 'User',
                          subtitle: user.email ?? 'No email',
                          isDarkMode: themeProvider.isDarkMode,
                          trailing: CircleAvatar(
                            radius: 20,
                            backgroundColor: themeProvider.primaryColor,
                            backgroundImage: user.photoURL != null
                                ? NetworkImage(user.photoURL!)
                                : null,
                            child: user.photoURL == null
                                ? Text(
                                    (user.displayName ?? 'U')[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }
                      return _buildSettingRow(
                        icon: Icons.person,
                        title: 'Not signed in',
                        subtitle: 'Sign in to sync your data',
                        isDarkMode: themeProvider.isDarkMode,
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => _buildSettingRow(
                      icon: Icons.error,
                      title: 'Error loading account',
                      subtitle: 'Please try again',
                      isDarkMode: themeProvider.isDarkMode,
                    ),
                  ),
                  const Divider(height: 32),
                  _buildActionButton(
                    icon: Icons.password,
                    title: 'Change Password',
                    onTap: () => _showChangePasswordDialog(context, themeProvider),
                    isDarkMode: themeProvider.isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () => _showSignOutDialog(context, themeProvider),
                    isDarkMode: themeProvider.isDarkMode,
                    isDestructive: true,
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    onTap: () => _showDeleteAccountDialog(context, themeProvider),
                    isDarkMode: themeProvider.isDarkMode,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // About Section
            _buildSectionHeader('About', themeProvider.isDarkMode),
            const SizedBox(height: 16),
            _buildCard(
              themeProvider.isDarkMode,
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: Icons.info,
                    title: 'Version',
                    subtitle: '1.0.0',
                    isDarkMode: themeProvider.isDarkMode,
                  ),
                  const Divider(height: 32),
                  _buildSettingRow(
                    icon: Icons.code,
                    title: 'TaskNet',
                    subtitle: 'The world\'s best task management app',
                    isDarkMode: themeProvider.isDarkMode,
                  ),
                  if (kIsWeb) ...[
                    const Divider(height: 32),
                    _buildActionButton(
                      icon: Icons.download,
                      title: 'Install App',
                      onTap: () {
                        download_helper.downloadApp();
                      },
                      isDarkMode: themeProvider.isDarkMode,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCard(bool isDarkMode, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : AppColors.borderLight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    Widget? trailing,
  }) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context, listen: false);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 24,
            color: themeProvider.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white60 : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : (isDarkMode ? Colors.white : AppColors.textPrimaryLight);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.3)
                  : (isDarkMode ? const Color(0xFF334155) : AppColors.borderLight),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: color.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, ThemeProvider themeProvider) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : null),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password change feature coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.primaryColor,
            ),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Sign Out',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : null),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider).signOut();
              widget.onLogout?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white70 : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : null),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion feature coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatefulWidget {
  final Color color;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorOption> createState() => _ColorOptionState();
}

class _ColorOptionState extends State<_ColorOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.color.withOpacity(0.2)
                : (_isHovered ? widget.color.withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isSelected ? widget.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? widget.color : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextSizeOption extends StatefulWidget {
  final String name;
  final double scale;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _TextSizeOption({
    required this.name,
    required this.scale,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_TextSizeOption> createState() => _TextSizeOptionState();
}

class _TextSizeOptionState extends State<_TextSizeOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.primaryColor.withOpacity(0.2)
                : (_isHovered ? widget.primaryColor.withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isSelected ? widget.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.text_fields,
                size: 20 * widget.scale,
                color: widget.isSelected ? widget.primaryColor : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? widget.primaryColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundColorOption extends StatefulWidget {
  final Color color;
  final String name;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _BackgroundColorOption({
    required this.color,
    required this.name,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_BackgroundColorOption> createState() => _BackgroundColorOptionState();
}

class _BackgroundColorOptionState extends State<_BackgroundColorOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.primaryColor.withOpacity(0.2)
                : (_isHovered ? widget.primaryColor.withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isSelected ? widget.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.isSelected
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: widget.primaryColor,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? widget.primaryColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
