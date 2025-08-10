import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:songquest/bloc/auth_bloc/auth_bloc.dart';
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
import 'package:songquest/router/routes.dart';
import 'package:songquest/helper/crashlytics_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Local Emulator Suite
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  // Initialize Crashlytics
  await CrashlyticsService().initialize();

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
  final authBloc = AuthBloc(authenticationRepository: authenticationRepo);

  APIServer().init(settingRepo);
  Cache().init(settingRepo, cacheRepo);
  Routes().init(settingRepo, authBloc);

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
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: settingRepo),
          RepositoryProvider.value(value: cacheRepo),
          RepositoryProvider.value(value: authenticationRepo),
        ],
        child: BlocProvider.value(value: authBloc, child: const App()),
      ),
    ),
  );
}
