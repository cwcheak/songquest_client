import 'package:dio/dio.dart';
import 'package:songquest/repo/authentication_repo.dart';
import 'package:songquest/helper/logger.dart';

class FirebaseAuthInterceptor extends Interceptor {
  final AuthenticationRepository authRepo;

  FirebaseAuthInterceptor({required this.authRepo});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await authRepo.getFirebaseToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        Logger.instance.d('Added Firebase token to request: ${options.uri}');
      } else {
        Logger.instance.d('No Firebase token available for request: ${options.uri}');
      }
    } catch (e) {
      Logger.instance.e('Failed to get Firebase token: $e');
    }

    handler.next(options);
  }
}
