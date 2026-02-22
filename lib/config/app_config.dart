import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration
/// Load environment variables from .env file
class AppConfig {
  AppConfig._();

  /// Initialize the config - call this in main() before runApp()
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  /// Backend API base URL from .env file
  /// Default to localhost for development if not set
  static String get backendBaseUrl => dotenv.env['BACKEND_URL'] ?? 'http://localhost11:8080';

  /// API endpoints
  static const String registerEndpoint = '/api/users/register';

  /// Full backend URL for registration
  static String get registerUrl => '$backendBaseUrl$registerEndpoint';
}
