import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/helper/go_router_refresh_stream.dart';
import 'package:songquest/screens/auth/login_screen.dart';
import 'package:songquest/screens/auth/register_screen.dart';
import 'package:songquest/screens/auth/forgot_password_screen.dart';
import 'package:songquest/screens/auth/confirmation_screen.dart';
import 'package:songquest/screens/bands/add_members_screen.dart';
import 'package:songquest/screens/bands/band_details_screen.dart';
import 'package:songquest/screens/bands/band_members_screen.dart';
import 'package:songquest/screens/bands/my_bands_screen.dart';
import 'package:songquest/screens/bands/scan_band_qr_screen.dart';
import 'package:songquest/screens/components/transition_resolver.dart';
import 'package:songquest/screens/on_stage/song_order_screen.dart';
import 'package:songquest/screens/debug/debug_screen.dart';
import 'package:songquest/screens/playlist/my_playlist_screen.dart';
import 'package:songquest/screens/playlist/add_song_screen.dart';
import 'package:songquest/screens/playlist/playlist_items_screen.dart';
import 'package:songquest/screens/account/account_screen.dart';
import 'package:songquest/screens/account/reject_reasons_screen.dart';
import 'package:songquest/screens/home/home_page.dart';
import 'package:songquest/screens/scaffold_home_page.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
import 'package:songquest/repo/settings_repo.dart';

class Routes {
  /// The base path of the app
  static const base = '/';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _orderNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'order');
  static final _menuNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'menu');
  static final _rewardsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rewards');
  static final _moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

  /// Singleton
  static final Routes _instance = Routes._internal();
  Routes._internal();

  factory Routes() {
    return _instance;
  }

  late final SettingsRepository _settingRepository;
  late final GoRouter _router;
  GoRouter get router => _router;

  init(SettingsRepository settingRepository, AuthBloc authBloc) {
    _settingRepository = settingRepository;
    initRoute(authBloc);
  }

  void initRoute(AuthBloc authBloc) {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        // Check authentication state using AuthBloc
        final authState = context.read<AuthBloc>().state;

        // If still checking auth state, stay on current route
        if (authState is AuthChecking) {
          return null;
        }

        final isAuthenticated = authState is AuthAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';
        final isRegisterRoute = state.matchedLocation == '/register';
        final isForgotPasswordRoute = state.matchedLocation == '/forgot-password';
        final isConfirmationRoute = state.matchedLocation == '/confirmation';

        Logger.instance.d('Redirecting to ${state.uri.path}');

        // Handle initial route determination
        if (state.matchedLocation == '/') {
          return isAuthenticated ? '/home' : '/login';
        }

        // Allow access to register, forgot password, or confirmation routes for unauthenticated users
        if (!isAuthenticated && (isRegisterRoute || isForgotPasswordRoute || isConfirmationRoute)) {
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
          path: '/',
          pageBuilder: (context, state) =>
              transitionResolver(const Scaffold(body: Center(child: CircularProgressIndicator()))),
        ),
        GoRoute(
          path: '/login',
          name: 'Login',
          pageBuilder: (context, state) => transitionResolver(const LoginScreen()),
        ),
        GoRoute(
          path: '/register',
          name: 'Register',
          pageBuilder: (context, state) => transitionResolver(const RegisterScreen()),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'Forgot Password',
          pageBuilder: (context, state) => transitionResolver(const ForgotPasswordScreen()),
        ),
        GoRoute(
          path: '/confirmation',
          name: 'Confirmation',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final email = extra?['email'] as String? ?? '';
            return transitionResolver(ConfirmationScreen(email: email));
          },
        ),
        GoRoute(
          path: '/my-playlist',
          name: 'My Playlist',
          pageBuilder: (context, state) => transitionResolver(const MyPlaylistScreen()),
        ),
        GoRoute(
          path: '/reject-reasons',
          name: 'Reject Reasons',
          pageBuilder: (context, state) => transitionResolver(const RejectReasonsScreen()),
        ),
        GoRoute(
          path: '/playlist-items',
          name: 'Playlist Items',
          pageBuilder: (context, state) => transitionResolver(const PlaylistItemsScreen()),
        ),
        GoRoute(
          path: '/add-song',
          name: 'Add Song',
          pageBuilder: (context, state) => transitionResolver(const AddSongScreen()),
        ),
        // GoRoute(
        //   path: '/my-bands',
        //   name: 'My Bands',
        //   pageBuilder: (context, state) => transitionResolver(const MyBandsScreen()),
        // ),
        GoRoute(
          path: '/scan-band-qr',
          name: 'Scan Band QR',
          pageBuilder: (context, state) => transitionResolver(const ScanBandQrScreen()),
        ),
        GoRoute(
          path: '/band-members',
          name: 'Band Members',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final bandName = extra?['bandName'] as String? ?? '';
            return transitionResolver(BandMembersScreen(bandName: bandName));
          },
        ),
        GoRoute(
          path: '/add-members',
          name: 'Add Members',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final bandName = extra?['bandName'] as String? ?? '';
            return transitionResolver(AddMembersScreen(bandName: bandName));
          },
        ),
        GoRoute(
          path: '/band-details',
          name: 'Band Details',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final bandName = extra?['bandName'] as String? ?? '';
            return transitionResolver(BandDetailsScreen(bandName: bandName));
          },
        ),
        // GoRoute(
        //   path: '/create-account',
        //   name: 'CreateAccount',
        //   pageBuilder: (context, state) =>
        //       transitionResolver(const AccountCreationScreen()),
        // ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => ScaffoldHomePage(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'Home',
                  pageBuilder: (context, state) => transitionResolver(const HomePage()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _orderNavigatorKey,
              routes: [
                GoRoute(
                  path: '/my-bands',
                  name: 'My Bands',
                  pageBuilder: (context, state) => transitionResolver(
                    // const Scaffold(body: Center(child: Text('Order'))),
                    const MyBandsScreen(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _menuNavigatorKey,
              routes: [
                GoRoute(
                  path: '/menu',
                  name: 'Menu',
                  pageBuilder: (context, state) => transitionResolver(const SongOrderScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _moreNavigatorKey,
              routes: [
                GoRoute(
                  path: '/settings',
                  name: 'More',
                  pageBuilder: (context, state) => transitionResolver(const AccountScreen()),
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
