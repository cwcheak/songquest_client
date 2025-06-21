import 'package:songquest/helper/logger.dart';

/// 数据库初始化
Future<void> migrate(db, oldVersion, newVersion) async {
  /*
  if (oldVersion <= 1) {
    await db.execute('''
          ALTER TABLE chat_room ADD COLUMN color TEXT;
          UPDATE chat_room SET color = 'FF4CAF50' WHERE category = 'system';
        ''');
  }
  */
}

void initDatabase(db, version) async {
  Logger.instance.i(
    'Initializing database. DB Path: ${db.path}, Version: $version',
  );

  await db.execute('''
        CREATE TABLE cache (
          `key` TEXT NOT NULL PRIMARY KEY,
          `value` TEXT NOT NULL,
          `group` TEXT NULL,
          `created_at` INTEGER,
          `valid_before` INTEGER
        )
      ''');

  await db.execute('''
      CREATE TABLE settings (
        `key` TEXT NOT NULL PRIMARY KEY,
        `value` TEXT NOT NULL
      );
  ''');
  /*
  await db.execute('''
        CREATE TABLE chat_room (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NULL,
          name TEXT NOT NULL,
          category TEXT NOT NULL,
          priority INTEGER DEFAULT 0,
          model TEXT NOT NULL,
          icon_data TEXT NOT NULL,
          color TEXT,
          description TEXT,
          system_prompt TEXT,
          init_message TEXT,
          max_context INTEGER DEFAULT 10,
          created_at INTEGER,
          last_active_time INTEGER 
        )
      ''');

  await db.execute('''
        INSERT INTO chat_room (id, name, category, priority, model, icon_data, color, created_at, last_active_time)
        VALUES (1, '随便聊聊', 'system', 99999, '$modelTypeOpenAI:$defaultChatModel', '57683,MaterialIcons', 'FF4CAF50', 1680969581486, ${DateTime.now().millisecondsSinceEpoch});
      ''');

  await db.execute('''
        CREATE TABLE chat_message (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NULL,
          room_id INTEGER NOT NULL,
          chat_history_id INTEGER NULL,
          type TEXT NOT NULL,
          role TEXT NOT NULL,
          user TEXT,
          text TEXT,
          extra TEXT,
          ref_id INTEGER NULL,
          server_id INTEGER NULL,
          status INTEGER DEFAULT 1,
          token_consumed INTEGER NULL,
          quota_consumed INTEGER NULL,
          model TEXT,
          images TEXT NULL,
          file TEXT NULL,
          flags TEXT NULL,
          ts INTEGER NOT NULL
        )
      ''');

  await db.execute('''
        CREATE TABLE chat_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NULL,
          room_id INTEGER NOT NULL,
          title TEXT,
          last_message TEXT,
          model TEXT,
          created_at INTEGER,
          updated_at INTEGER
        )
      ''');

  await db.execute('''
        CREATE TABLE cache (
          `key` TEXT NOT NULL PRIMARY KEY,
          `value` TEXT NOT NULL,
          `group` TEXT NULL,
          `created_at` INTEGER,
          `valid_before` INTEGER
        )
      ''');

  await db.execute('''
        CREATE TABLE creative_island_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NULL,
          item_id TEXT NOT NULL,
          arguments TEXT NULL,
          prompt TEXT NULL,
          answer TEXT NULL,
          task_id TEXT NULL,
          status TEXT NULL,
          created_at INTEGER NOT NULL
        ) 
      ''');

  await db.execute('''
      CREATE TABLE settings (
        `key` TEXT NOT NULL PRIMARY KEY,
        `value` TEXT NOT NULL
      );
  ''');
  */

  // await initUserDefaultRooms(db);
}
