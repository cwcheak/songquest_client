import 'package:songquest/repo/cache_repo.dart';
import 'package:songquest/repo/settings_repo.dart';

class Cache {
  late final SettingsRepository setting;
  late final CacheRepository cacheRepo;

  init(SettingsRepository setting, CacheRepository cacheRepo) {
    this.setting = setting;
    this.cacheRepo = cacheRepo;
  }

  /// Singleton
  static final Cache _instance = Cache._internal();
  Cache._internal();

  factory Cache() {
    return _instance;
  }

  Future<bool> boolGet({required String key}) async {
    var value = await cacheRepo.get(key);
    if (value == null || value.isEmpty || value == 'true') {
      return true;
    }

    return false;
  }

  Future<void> remove({required String key}) async {
    await cacheRepo.remove(key);
  }

  Future<void> clearAll() async {
    await cacheRepo.clearAll();
  }

  Future<void> setBool({
    required String key,
    required bool value,
    Duration duration = const Duration(days: 1),
  }) async {
    await cacheRepo.set(key, value.toString(), duration);
  }

  Future<void> setString({
    required String key,
    required String value,
    Duration duration = const Duration(days: 1),
  }) async {
    await cacheRepo.set(key, value, duration);
  }

  Future<String?> stringGet({required String key}) async {
    return await cacheRepo.get(key);
  }

  Future<int> setInt({
    required String key,
    required int value,
    Duration duration = const Duration(days: 1),
  }) async {
    await cacheRepo.set(key, value.toString(), duration);
    return value;
  }

  Future<int> intGet({required String key}) async {
    var value = await cacheRepo.get(key);
    if (value == null || value.isEmpty) {
      return 0;
    }

    return int.parse(value);
  }
}
