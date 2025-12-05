import 'package:sqflite/sqflite.dart';

class DisclaimerDatabaseHelper {
  static const _databaseName = "AppDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'disclaimer_status';
  static const columnId = 'id';
  static const columnIsAcknowledged =
      'is_acknowledged'; // INTEGER: 1 for true, 0 for false

  // Singleton instance
  DisclaimerDatabaseHelper._privateConstructor();
  static final DisclaimerDatabaseHelper instance =
      DisclaimerDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates the table.
  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath() + _databaseName;
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// SQL code to create the table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnIsAcknowledged INTEGER NOT NULL DEFAULT 0
      )
    ''');
    // Ensure the table always has exactly one row to manage the state
    await db.insert(table, {columnId: 1, columnIsAcknowledged: 0});
  }

  // --- CRUD Operations ---

  /// Retrieves the acknowledgment status (true if 1, false if 0).
  Future<bool> getDisclaimerStatus() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnId = 1',
    );

    if (result.isNotEmpty) {
      // If result is 1, return true; otherwise, false.
      return result.first[columnIsAcknowledged] == 1;
    }

    // Should not happen if _onCreate ran correctly, but as fallback:
    return false;
  }

  /// Sets the acknowledgment status to true (1) after the user agrees.
  Future<int> updateDisclaimerStatus({required bool acknowledged}) async {
    Database db = await instance.database;
    int acknowledgedValue = acknowledged ? 1 : 0;

    // Update the single row where ID is 1
    return await db.update(table, {
      columnIsAcknowledged: acknowledgedValue,
    }, where: '$columnId = 1');
  }
}
