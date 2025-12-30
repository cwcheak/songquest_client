import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme extends ChangeNotifier {
  static FlexScheme get usedScheme => FlexScheme.blueWhale;
  // static FlexScheme get usedScheme => FlexScheme.material;
  static bool get useMaterial3 => true;
  // static Color primaryColor = Colors.black;
  static Color primaryColor = Color(0xFF2A3662);

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

  static ThemeData createLightThemeData_bak() {
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
    ).copyWith(
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      colorScheme:
          FlexThemeData.light(
            scheme: usedScheme,
            surfaceMode: FlexSurfaceMode.level,
            blendLevel: 7,
            useMaterial3: useMaterial3,
          ).colorScheme.copyWith(
            surface: const Color(0xFFF2F3F8), // New surface color
          ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  static ThemeData createLightThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        primary: primaryColor,
        brightness: Brightness.light,
      ),
      primaryColor: primaryColor,
      textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: const TextStyle(fontWeight: FontWeight.w600),
        titleSmall: const TextStyle(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        // backgroundColor: Color.fromARGB(255, 245, 245, 245),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black, // Back button color
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(color: Color.fromARGB(255, 245, 245, 245)),
      scaffoldBackgroundColor: const Color.fromARGB(255, 242, 242, 242),
      // scaffoldBackgroundColor: Colors.transparent,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey[200],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        labelTextStyle: const WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 11.0)),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 3,
      ),
    );
  }

  // // For the new Material 3 NavigationBar
  //   navigationBarTheme: NavigationBarThemeData(
  //     backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Your desired color
  //     // Optional: other customizations
  //     indicatorColor: Colors.blue.withOpacity(0.2),
  //     labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  //   ),

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
    ).copyWith(
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
      colorScheme:
          FlexThemeData.dark(
            scheme: usedScheme,
            surfaceMode: FlexSurfaceMode.level,
            blendLevel: 7,
            useMaterial3: useMaterial3,
          ).colorScheme.copyWith(
            // surface: const Color(0xFFF2F3F8), // New surface color
            surface: const Color(0xD9DADF), // New surface color
          ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
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
