import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:songquest/app.dart';
// import 'package:songquest/helper/ability.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/helper/constant.dart';
import 'package:songquest/helper/cache.dart';
import 'package:songquest/data/migrate.dart';
// import 'package:songquest/repo/api/Capabilities.dart';
import 'package:songquest/repo/cache_repo.dart';
import 'package:songquest/repo/data/cache_data.dart';
import 'package:songquest/repo/data/settings_data.dart';
import 'package:songquest/repo/settings_repo.dart';
import 'package:songquest/repo/api_server.dart';
import 'package:songquest/repo/authentication_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Local Emulator Suite
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // await FirebaseAuth.instance.signOut();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.library == 'rendering library' ||
        details.library == 'image resource service') {
      return;
    }

    Logger.instance.e(
      details.summary,
      error: details.exception,
      stackTrace: details.stack,
    );
    Logger.instance.d(details.stack);
  };

  // Open and load database, if need to perform version migration
  final db = await databaseFactory.openDatabase(
    'system.db',
    options: OpenDatabaseOptions(
      version: databaseVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        try {
          await migrate(db, oldVersion, newVersion);
        } catch (e) {
          Logger.instance.e('Database upgrade failure', error: e);
        }
      },
      onCreate: initDatabase,
      onOpen: (db) {
        Logger.instance.i('Database storage path: ${db.path}');
      },
    ),
  );

  // Load settings
  final settingProvider = SettingDataProvider(db);
  await settingProvider.loadSettings();

  final settingRepo = SettingsRepository(settingProvider);
  final cacheRepo = CacheRepository(CacheDataProvider(db));
  final authenticationRepo = AuthenticationRepository();

  APIServer().init(settingRepo);
  Cache().init(settingRepo, cacheRepo);

  // Retrieve client's ability from server
  /*
  try {
    final capabilities = await APIServer().capabilities(cache: false);
    Ability().init(settingRepo, capabilities);
  } catch (e) {
    Logger.instance.e('Failed to get the client capability manifest', error: e);
    Ability().init(settingRepo, Capabilities(manageSalesItemEnabled: false));
  }
  */

  runApp(
    Phoenix(
      //child: MyApp(),
      child: App(
        settingRepo: settingRepo,
        cacheRepo: cacheRepo,
        authenticationRepo: authenticationRepo,
      ),
    ),
  );
}
