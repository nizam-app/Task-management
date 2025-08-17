import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/shift_provider.dart';
import 'providers/staff_provider.dart';
import 'providers/message_provider.dart';
import 'screens/role_selection_screen.dart';
import 'screens/staff/staff_main_screen.dart';
import 'screens/manager/manager_main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const EDMSolutionsApp());
}

class EDMSolutionsApp extends StatelessWidget {
  const EDMSolutionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShiftProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'EDM Solutions',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: _createRouter(authProvider),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final userRole = authProvider.userRole;
        
        if (!isLoggedIn && state.location != '/') {
          return '/';
        }
        
        if (isLoggedIn && state.location == '/') {
          return userRole == 'staff' ? '/staff' : '/manager';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        GoRoute(
          path: '/staff',
          builder: (context, state) => const StaffMainScreen(),
        ),
        GoRoute(
          path: '/manager',
          builder: (context, state) => const ManagerMainScreen(),
        ),
      ],
    );
  }
}