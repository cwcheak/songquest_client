/// Capabilities supported by the client
class Capabilities {
  /// Define Sentry log level
  final String logLevel;

  /// Allowed to create/update/delete sales item
  final bool manageSalesItemEnabled;

  Capabilities({this.logLevel = 'info', this.manageSalesItemEnabled = false});

  factory Capabilities.fromJson(Map<String, dynamic> json) {
    return Capabilities(
      logLevel: 'debug',
      manageSalesItemEnabled: json['manage_sales_item_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logLevel': 'info',
      'manage_sales_item_enabled': manageSalesItemEnabled,
    };
  }
}
