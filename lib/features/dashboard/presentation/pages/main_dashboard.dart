import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../shared/widgets/flux_logo.dart';
import '../../../../widgets/task_creation_dialog.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'tasks_page.dart';
import 'calendar_page.dart';

class MainDashboard extends ConsumerStatefulWidget {
  final VoidCallback onLogout;

  const MainDashboard({super.key, required this.onLogout});

  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  int _selectedIndex = 0;

  final List<String> _pageNames = ['Tasks', 'Calendar', 'Settings'];

  List<Widget> get _pages => [
    const TasksPage(),
    const CalendarPage(),
    SettingsPage(onLogout: widget.onLogout),
  ];

  void _showTaskCreationDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaskCreationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF0F172A)
          : themeProvider.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              children: [
                _buildMobileHeader(authState, themeProvider),
                Expanded(child: _pages[_selectedIndex]),
                _buildBottomNavigationBar(),
              ],
            );
          }

          return Row(
            children: [
              _buildSidebar(authState, themeProvider),
              Expanded(child: _pages[_selectedIndex]),
            ],
          );
        },
      ),
      floatingActionButton: _HoverFAB(
        onPressed: _showTaskCreationDialog,
      ),
    );
  }

  Widget _buildMobileHeader(AsyncValue authState, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: themeProvider.isDarkMode
                ? const Color(0xFF334155)
                : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FluxLogo(height: 80),
          authState.when(
            data: (user) {
              if (user != null) {
                return Row(
                  children: [
                    Text(
                      user.displayName ?? 'User',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 16,
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
                                fontSize: 14,
                              ),
                            )
                          : null,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(AsyncValue authState, ThemeProvider themeProvider) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          right: BorderSide(
            color: themeProvider.isDarkMode
                ? const Color(0xFF334155)
                : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: FluxLogo(height: 90),
          ),
          Divider(
            height: 1,
            color: themeProvider.isDarkMode
                ? const Color(0xFF334155)
                : AppColors.borderLight,
          ),
          // User Profile Section
          authState.when(
            data: (user) {
              if (user != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? 'User',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user.email ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: themeProvider.isDarkMode
                                    ? Colors.white60
                                    : AppColors.textSecondaryLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 16);
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const SizedBox(height: 16),
          ),
          Divider(
            height: 1,
            color: themeProvider.isDarkMode
                ? const Color(0xFF334155)
                : AppColors.borderLight,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  icon: Icons.checklist,
                  label: 'Tasks',
                  index: 0,
                  themeProvider: themeProvider,
                ),
                _buildNavItem(
                  icon: Icons.calendar_today,
                  label: 'Calendar',
                  index: 1,
                  themeProvider: themeProvider,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  index: 2,
                  themeProvider: themeProvider,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: themeProvider.isDarkMode
                ? const Color(0xFF334155)
                : AppColors.borderLight,
          ),
          _buildLogoutButton(themeProvider),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required ThemeProvider themeProvider,
  }) {
    final isSelected = _selectedIndex == index;

    return _HoverNavItem(
      isSelected: isSelected,
      themeProvider: themeProvider,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? themeProvider.primaryColor
              : (themeProvider.isDarkMode
                  ? Colors.white60
                  : AppColors.textSecondaryLight),
        ),
        title: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? themeProvider.primaryColor
                : (themeProvider.isDarkMode
                    ? Colors.white
                    : AppColors.textPrimaryLight),
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _HoverButton(
        onPressed: widget.onLogout,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

}

class _HoverFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const _HoverFAB({required this.onPressed});

  @override
  State<_HoverFAB> createState() => _HoverFABState();
}

class _HoverFABState extends State<_HoverFAB> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: _isHovered
              ? AppColors.primary.withOpacity(0.9)
              : AppColors.primary,
          elevation: _isHovered ? 8 : 4,
          child: const Icon(
            Icons.add,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _HoverNavItem extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final ThemeProvider themeProvider;

  const _HoverNavItem({
    required this.child,
    required this.isSelected,
    required this.themeProvider,
  });

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? widget.themeProvider.primaryColor.withOpacity(0.1)
              : _isHovered
                  ? (widget.themeProvider.isDarkMode
                      ? const Color(0xFF334155)
                      : AppColors.surfaceLight)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.child,
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _HoverButton({
    required this.onPressed,
    required this.child,
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
                ? AppColors.error.withOpacity(0.9)
                : AppColors.error,
            foregroundColor: Colors.white,
            elevation: _isHovered ? 4 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
