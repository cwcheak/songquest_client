import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:songquest/screens/components/theme/theme.dart';
import 'package:songquest/repo/settings_repo.dart';
import 'package:songquest/router/routes.dart';
import 'package:songquest/helper/constant.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class App extends StatefulWidget {
  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static ValueNotifier<RoutingConfig>? routingConfig;

  // singleton be avoid recreate after hot reload.
  static RouterConfig<Object>? router;

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppTheme.get()
        ..mode = AppTheme.themeModeFormString(
          context.read<SettingsRepository>().stringDefault(
            settingThemeMode,
            'system',
          ),
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
    );
  }
}
