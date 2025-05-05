// lib/core/database/local/sembast_db.dart
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class SembastDb {
  Database? _database;
  static const String dbName = 'app_local.db';

  Future<Database> get database async {
    if (_database == null) {
      await _initDb();
    }
    return _database!;
  }

  Future<void> _initDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, dbName);
    _database = await databaseFactoryIo.openDatabase(dbPath);
    print("Sembast database initialized at: $dbPath");
  }

  // Optional: Close DB on app dispose
  Future<void> closeDb() async {
    await _database?.close();
    _database = null;
  }
}
