import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:songquest/helper/error.dart';
import 'dart:convert';
import 'package:songquest/helper/event.dart';
import 'package:songquest/helper/http.dart';
import 'package:songquest/screens/components/global_alert.dart';
import 'package:songquest/repo/api/Capabilities.dart';
import 'package:songquest/repo/settings_repo.dart';
import 'package:songquest/helper/constant.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/helper/env.dart';
import 'package:songquest/helper/platform.dart';

class APIServer {
  /// Singleton
  static final APIServer _instance = APIServer._internal();
  APIServer._internal();

  factory APIServer() {
    return _instance;
  }

  GlobalAlertEvent _globalAlertEvent = GlobalAlertEvent(
    id: '',
    type: 'info',
    pages: [],
    message: '',
  );

  GlobalAlertEvent get globalAlertEvent => _globalAlertEvent;

  late String url;
  late String apiToken;
  late String language;

  /// Initialize APIServer
  init(SettingsRepository setting) {
    apiToken = setting.stringDefault(settingAPIServerToken, '');
    language = setting.stringDefault(settingLanguage, 'en');
    url = setting.stringDefault(settingServerURL, apiServerURL);

    Logger.instance.d('API Server URL: $url');

    setting.listen((settings, key, value) {
      if (key == settingAPIServerToken) {
        apiToken = settings.getDefault(settingAPIServerToken, '');
      }

      if (key == settingLanguage) {
        language = settings.getDefault(settingLanguage, 'zh');
      }

      if (key == settingServerURL) {
        url = settings.getDefault(settingServerURL, apiServerURL);
        Logger.instance.d('API Server URL Changed: $url');
      }
    });
  }

  final List<DioExceptionType> _retryableErrors = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  ];

  /// 异常处理
  Object _exceptionHandle(Object e, Object? stackTrace) {
    Logger.instance.e(e, stackTrace: stackTrace as StackTrace?);

    if (e is DioException) {
      if (e.response != null) {
        final resp = e.response!;

        if (resp.data is Map &&
            resp.data['error'] != null &&
            resp.statusCode != 402 &&
            resp.statusCode != 401) {
          return resp.data['error'] ?? e.toString();
        }

        if (resp.statusCode != null) {
          final ret = resolveHTTPStatusCode(resp.statusCode!);
          if (ret != null) {
            return ret;
          }
        }

        return resp.statusMessage ?? e.toString();
      }

      if (_retryableErrors.contains(e.type)) {
        return 'Timeout when connecting to server. Please try again.';
      }
    }

    return e.toString();
  }

  Map<String, dynamic> _buildAuthHeaders() {
    final headers = <String, dynamic>{
      'X-CLIENT-VERSION': clientVersion,
      'X-PLATFORM': PlatformTool.operatingSystem(),
      'X-PLATFORM-VERSION': PlatformTool.operatingSystemVersion(),
      'X-LANGUAGE': language,
    };

    if (apiToken == '') {
      return headers;
    }

    headers['Authorization'] = 'Bearer $apiToken';

    return headers;
  }

  Options _buildRequestOptions({int? requestTimeout = 10000}) {
    return Options(
      headers: _buildAuthHeaders(),
      receiveDataWhenStatusError: true,
      sendTimeout: requestTimeout != null
          ? Duration(milliseconds: requestTimeout)
          : null,
      receiveTimeout: requestTimeout != null
          ? Duration(milliseconds: requestTimeout)
          : null,
    );
  }

  Future<T> request<T>(
    Future<Response<dynamic>> respFuture,
    T Function(dynamic) parser, {
    VoidCallback? finallyCallback,
  }) async {
    try {
      final resp = await respFuture;
      if (resp.statusCode != 200 && resp.statusCode != 304) {
        return Future.error(resp.data['error']);
      }

      try {
        var msg = resp.headers.value('tdmpos-global-alert-msg');
        if (msg != null) {
          msg = utf8.decode(base64Decode(msg));
        }

        // Logger.instance.d("API Response: ${resp.data}");
        final globalAlertEvent = GlobalAlertEvent(
          id: resp.headers.value('tdmpos-global-alert-id') ?? '',
          type: resp.headers.value('tdmpos-global-alert-type') ?? 'info',
          pages: (resp.headers.value('tdmpos-global-alert-pages') ?? '')
              .split(',')
              .where((e) => e != '')
              .toList(),
          message: msg,
        );

        if (globalAlertEvent.id != '' &&
            globalAlertEvent.id != _globalAlertEvent.id) {
          _globalAlertEvent = globalAlertEvent;
          GlobalEvent().emit('global-alert', _globalAlertEvent);
        }
      } catch (e) {
        Logger.instance.e(e);
      }

      return parser(resp);
    } catch (e, stackTrace) {
      return Future.error(_exceptionHandle(e, stackTrace));
    } finally {
      finallyCallback?.call();
    }
  }

  Future<T> sendCachedGetRequest<T>(
    String endpoint,
    T Function(dynamic) parser, {
    String? subKey,
    Duration duration = const Duration(days: 1),
    Map<String, dynamic>? queryParameters,
    bool forceRefresh = false,
  }) async {
    return request(
      HttpClient.getCached(
        '$url$endpoint',
        queryParameters: queryParameters,
        subKey: subKey,
        duration: duration,
        forceRefresh: forceRefresh,
        options: _buildRequestOptions(),
      ),
      parser,
    );
  }

  //FIXME: Change the server url to retrieve the server capability
  /// 服务器支持的能力
  Future<Capabilities> capabilities({bool cache = true}) async {
    return sendCachedGetRequest(
      '/public/info/capabilities',
      (resp) => Capabilities.fromJson(resp.data),
      forceRefresh: !cache,
    );
  }

  // /// Get UserInfo from server
  // Future<UserInfo?> userInfo({bool cache = true}) async {
  //   return sendCachedGetRequest(
  //     '/v1/users/current',
  //     (resp) => UserInfo.fromJson(resp.data),
  //     duration: const Duration(minutes: 1),
  //     subKey: _cacheSubKey(),
  //     forceRefresh: !cache,
  //   );
  // }
}
