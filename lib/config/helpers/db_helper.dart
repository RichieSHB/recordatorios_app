import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> _initDatabasePath() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'legal_reminders.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE cases (id INTEGER PRIMARY KEY, case_name TEXT, client_name TEXT, subject TEXT, description TEXT, event_date TEXT,event_time TEXT, reminder_date TEXT, reminder_time TEXT)',
        );
      },
    );
  }

  static Future<void> insertCase(
    String caseName,
    String clientName,
    String subject,
    String description,
    String eventDate,
    String eventTime,
    String reminderDate,
    String reminderTime,
  ) async {
    final db = await _initDatabasePath();
    await db.insert('cases', {
      'case_name': caseName,
      'client_name': clientName,
      'subject': subject,
      'description': description,
      'event_date': eventDate,
      'event_time': eventTime,
      'reminder_date': reminderDate,
      'reminder_time': reminderTime,
    });
  }

  static Future<List<Map<String, dynamic>>> getCases() async {
    final db = await _initDatabasePath();
    return await db.query('cases');
  }
}
