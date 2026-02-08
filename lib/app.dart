import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/main_dashboard.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';

// Custom scroll behavior for smooth scrolling
class SmoothScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Return child without scrollbar
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.fast,
    );
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class FluxApp extends StatelessWidget {
  const FluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const _FluxAppContent(),
    );
  }
}

class _FluxAppContent extends StatefulWidget {
  const _FluxAppContent();

  @override
  State<_FluxAppContent> createState() => _FluxAppContentState();
}

class _FluxAppContentState extends State<_FluxAppContent> {
  int _currentStage = 0; // 0: HomePage, 1: LoginPage, 2: Dashboard
  String? _userId;

  void _navigateToLogin() {
    setState(() {
      _currentStage = 1;
    });
  }

  void _navigateToDashboard(String userId) {
    setState(() {
      _userId = userId;
      _currentStage = 2;
    });
    // Load tasks for this user
    context.read<TaskProvider>().loadTasksForUser(userId);
    // Load user's theme preferences
    context.read<ThemeProvider>().loadUserPreferences(userId);
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // Clear tasks
    context.read<TaskProvider>().clearTasks();
    // Reset theme to defaults
    context.read<ThemeProvider>().resetToDefaults();
    setState(() {
      _userId = null;
      _currentStage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flux',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          scrollBehavior: SmoothScrollBehavior(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(themeProvider.textScaleFactor),
              ),
              child: child!,
            );
          },
          home: IndexedStack(
            index: _currentStage,
            children: [
              HomePage(
                onGetStarted: _navigateToLogin,
                onLogin: _navigateToLogin,
                onSignUp: _navigateToLogin,
              ),
              LoginPage(onLogin: _navigateToDashboard),
              MainDashboard(onLogout: _logout),
            ],
          ),
        );
      },
    );
  }
}
