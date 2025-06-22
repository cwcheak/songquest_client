import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme extends ChangeNotifier {
  static FlexScheme get usedScheme => FlexScheme.blueWhale;
  static bool get useMaterial3 => true;

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  AppTheme(String mode) {
    switch (mode) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
  }

  static AppTheme instance = AppTheme('system');

  static AppTheme get() {
    if (!instance.mounted) {
      instance = AppTheme('system');
    }

    return instance;
  }

  static ThemeMode themeModeFormString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static ThemeData createLightThemeData() {
    return FlexThemeData.light(
      scheme: usedScheme,
      // Blending in primary color into surface, background, scaffoldBackground and dialogBackground colors
      surfaceMode: FlexSurfaceMode.level,
      // Blend level strength used by the used surfaceMode
      blendLevel: 7,
      // Use very subtly themed app bar elevation in light mode.
      appBarElevation: 0.5,
      // Opt in/out of using Material 3.
      useMaterial3: useMaterial3,
      swapLegacyOnMaterial3: true,
      // We use the nicer Material 3 Typography in both M2 and M3 mode.
      typography: Typography.material2021(platform: defaultTargetPlatform),
    );
  }

  static ThemeData createDarkThemeData() {
    return FlexThemeData.dark(
      scheme: usedScheme,
      // Blending in primary color into surface, background, scaffoldBackground and dialogBackground colors
      surfaceMode: FlexSurfaceMode.level,
      // Blend level strength used by the used surfaceMode
      blendLevel: 7,
      // Use a bit more themed elevated app bar in dark mode.
      appBarElevation: 2,
      // Opt in/out of using Material 3.
      useMaterial3: useMaterial3,
      swapLegacyOnMaterial3: true,
      // We use the nicer Material 3 Typography in both M2 and M3 mode.
      typography: Typography.material2021(platform: defaultTargetPlatform),
    );
  }

  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  bool _mounted = false;
  bool get mounted => _mounted;

  @override
  void dispose() {
    super.dispose();
    _mounted = true;
  }
}
