import 'package:songquest/helper/constant.dart';
import 'package:songquest/repo/api/Capabilities.dart';
import 'package:songquest/repo/settings_repo.dart';

class Ability {
  late final SettingsRepository setting;
  late Capabilities capabilities;

  init(SettingsRepository setting, Capabilities capabilities) {
    this.setting = setting;
    this.capabilities = capabilities;
  }

  /// Singleton
  static final Ability _instance = Ability._internal();
  Ability._internal();

  factory Ability() {
    return _instance;
  }

  /// Display global alert?
  bool get showGlobalAlert {
    return true;
  }

  /// Allowed to manage sales item
  bool get manageSalesItemEnabled {
    return capabilities.manageSalesItemEnabled;
  }

  /// 更新能力
  updateCapabilities(Capabilities capabilities) {
    this.capabilities = capabilities;
  }

  /// 是否用户已经登陆
  bool isUserLogon() {
    return setting.stringDefault(settingAPIServerToken, '') != '';
  }
}
