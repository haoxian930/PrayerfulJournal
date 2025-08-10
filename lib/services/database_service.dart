import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prayer_request.dart';
import '../models/prayer_prompt.dart';

class DatabaseService {
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'prayerful_journey.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Prayer Requests table
    await db.execute('''
      CREATE TABLE prayer_requests (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category INTEGER NOT NULL,
        status INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        answered_at TEXT,
        answered_story_id TEXT
      )
    ''');

    // Answered Prayer Stories table
    await db.execute('''
      CREATE TABLE answered_prayer_stories (
        id TEXT PRIMARY KEY,
        prayer_request_id TEXT NOT NULL,
        title TEXT NOT NULL,
        narrative TEXT NOT NULL,
        reflection TEXT,
        answered_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        photo_path TEXT,
        gods_fingerprints TEXT,
        FOREIGN KEY (prayer_request_id) REFERENCES prayer_requests (id)
      )
    ''');

    // Journal Entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        linked_prayer_request_id TEXT,
        linked_answered_story_id TEXT,
        tags TEXT,
        FOREIGN KEY (linked_prayer_request_id) REFERENCES prayer_requests (id),
        FOREIGN KEY (linked_answered_story_id) REFERENCES answered_prayer_stories (id)
      )
    ''');

    // Prayer Prompts table
    await db.execute('''
      CREATE TABLE prayer_prompts (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Insert default prayer prompts
    for (var prompt in PrayerPrompt.defaultPrompts) {
      await db.insert('prayer_prompts', prompt.toMap());
    }

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_prayer_requests_status ON prayer_requests(status)');
    await db.execute('CREATE INDEX idx_prayer_requests_category ON prayer_requests(category)');
    await db.execute('CREATE INDEX idx_answered_stories_date ON answered_prayer_stories(answered_date)');
    await db.execute('CREATE INDEX idx_journal_entries_date ON journal_entries(created_at)');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades in future versions
    if (oldVersion < newVersion) {
      // Migration logic would go here
    }
  }

  // Prayer Requests CRUD operations
  Future<String> insertPrayerRequest(PrayerRequest request) async {
    final db = await database;
    await db.insert('prayer_requests', request.toMap());
    return request.id;
  }

  Future<List<PrayerRequest>> getAllPrayerRequests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_requests',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => PrayerRequest.fromMap(maps[i]));
  }

  Future<List<PrayerRequest>> getPrayerRequestsByStatus(PrayerRequestStatus status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_requests',
      where: 'status = ?',
      whereArgs: [status.index],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => PrayerRequest.fromMap(maps[i]));
  }

  Future<PrayerRequest?> getPrayerRequestById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PrayerRequest.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePrayerRequest(PrayerRequest request) async {
    final db = await database;
    return await db.update(
      'prayer_requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<int> deletePrayerRequest(String id) async {
    final db = await database;
    return await db.delete(
      'prayer_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Prayer Prompts operations
  Future<List<PrayerPrompt>> getAllPrayerPrompts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prayer_prompts',
      where: 'is_active = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => PrayerPrompt.fromMap(maps[i]));
  }

  Future<PrayerPrompt?> getRandomPrayerPrompt() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM prayer_prompts WHERE is_active = 1 ORDER BY RANDOM() LIMIT 1',
    );
    if (maps.isNotEmpty) {
      return PrayerPrompt.fromMap(maps.first);
    }
    return null;
  }

  // Statistics methods
  Future<Map<String, int>> getPrayerStatistics() async {
    final db = await database;
    
    final totalRequests = await db.rawQuery('SELECT COUNT(*) as count FROM prayer_requests');
    final answeredRequests = await db.rawQuery('SELECT COUNT(*) as count FROM prayer_requests WHERE status = ?', [PrayerRequestStatus.answered.index]);
    
    return {
      'totalRequests': totalRequests.first['count'] as int,
      'answeredRequests': answeredRequests.first['count'] as int,
    };
  }

  // Export data for backup
  Future<Map<String, dynamic>> exportAllData() async {
    final prayerRequests = await getAllPrayerRequests();
    
    return {
      'prayerRequests': prayerRequests.map((e) => e.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Clean up resources
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
