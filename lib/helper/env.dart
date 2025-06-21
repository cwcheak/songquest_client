const defaultAPIServerURL = 'https://localhost:8080';

String get apiServerURL {
  var url = const String.fromEnvironment(
    'API_SERVER_URL',
    defaultValue: defaultAPIServerURL,
  );

  return url;
}
