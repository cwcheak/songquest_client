/// Capabilities supported by the client
class Capabilities {
  /// Allowed to create/update/delete sales item
  final bool manageSalesItemEnabled;

  Capabilities({
    this.manageSalesItemEnabled = false,
  });

  factory Capabilities.fromJson(Map<String, dynamic> json) {
    return Capabilities(
      manageSalesItemEnabled: json['manage_sales_item_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manage_sales_item_enabled': manageSalesItemEnabled,
    };
  }
}
