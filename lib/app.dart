import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:songquest/screens/components/theme/theme.dart';
import 'package:songquest/repo/cache_repo.dart';
import 'package:songquest/repo/settings_repo.dart';
import 'package:songquest/router/routes.dart';
import 'package:songquest/helper/constant.dart';
import 'package:songquest/repo/authentication_repo.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';

class App extends StatefulWidget {
  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static ValueNotifier<RoutingConfig>? routingConfig;

  // singleton be avoid recreate after hot reload.
  static RouterConfig<Object>? router;

  late final SettingsRepository settingRepo;
  late final CacheRepository cacheRepo;
  late final AuthenticationRepository authenticationRepo;

  App({
    super.key,
    required this.settingRepo,
    required this.cacheRepo,
    required this.authenticationRepo,
  }) {
    Routes().init(settingRepo);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsRepository>(
          create: (context) => widget.settingRepo,
        ),
        RepositoryProvider<CacheRepository>(
          create: (context) => widget.cacheRepo,
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => widget.authenticationRepo,
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: ChangeNotifierProvider(
          create: (context) => AppTheme.get()
            ..mode = AppTheme.themeModeFormString(
              widget.settingRepo.stringDefault(settingThemeMode, 'system'),
            ),
          builder: (context, _) {
            final appTheme = context.watch<AppTheme>();

            return Sizer(
              builder: (context, orientation, deviceType) {
                return MaterialApp.router(
                  title: appTitle,
                  themeMode: appTheme.mode,
                  theme: AppTheme.createLightThemeData(),
                  darkTheme: AppTheme.createDarkThemeData(),
                  debugShowCheckedModeBanner: false,
                  routerConfig: Routes().router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
