import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/screens/auth/login_screen.dart';
import 'package:songquest/screens/auth/register_screen.dart';
import 'package:songquest/screens/auth/forgot_password_screen.dart';
import 'package:songquest/screens/components/transition_resolver.dart';
import 'package:songquest/screens/settings/settings_screen.dart';
import 'package:songquest/screens/home/home_page.dart';
import 'package:songquest/screens/scaffold_home_page.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/repo/settings_repo.dart';

class Routes {
  /// The base path of the app
  static const base = '/';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final _moreNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'more',
  );

  /// Singleton
  static final Routes _instance = Routes._internal();
  Routes._internal();

  factory Routes() {
    return _instance;
  }

  late final SettingsRepository _settingRepository;
  late final GoRouter _router;
  GoRouter get router => _router;

  init(SettingsRepository settingRepository) {
    _settingRepository = settingRepository;
    initRoute();
  }

  void initRoute() {
    _router = GoRouter(
      initialLocation: '/login',
      navigatorKey: _rootNavigatorKey,
      redirect: (context, state) {
        // Check authentication state using AuthBloc
        final authState = context.read<AuthBloc>().state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isLoginRoute = state.uri.path == '/login';
        final isRegisterRoute = state.uri.path == '/register';
        final isForgotPasswordRoute = state.uri.path == '/forgot-password';

        // Allow access to register or forgot password routes for unauthenticated users
        if (!isAuthenticated && (isRegisterRoute || isForgotPasswordRoute)) {
          return null;
        }

        // Redirect to login if not authenticated and not on login or register route
        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        // Redirect to home if authenticated and on login route
        if (isAuthenticated && isLoginRoute) {
          return '/home';
        }

        // No redirection needed
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'Login',
          pageBuilder: (context, state) =>
              transitionResolver(const LoginScreen()),
        ),
        GoRoute(
          path: '/register',
          name: 'Register',
          pageBuilder: (context, state) =>
              transitionResolver(const RegisterScreen()),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'Forgot Password',
          pageBuilder: (context, state) =>
              transitionResolver(const ForgotPasswordScreen()),
        ),
        // GoRoute(
        //   path: '/create-account',
        //   name: 'CreateAccount',
        //   pageBuilder: (context, state) =>
        //       transitionResolver(const AccountCreationScreen()),
        // ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              ScaffoldHomePage(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'Home',
                  pageBuilder: (context, state) =>
                      transitionResolver(const HomePage()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _moreNavigatorKey,
              routes: [
                GoRoute(
                  path: '/settings',
                  name: 'More',
                  pageBuilder: (context, state) => transitionResolver(
                    SettingsScreen(settingsRepo: _settingRepository),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    );
  }
}
