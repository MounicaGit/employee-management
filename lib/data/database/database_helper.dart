import 'package:employee_management/data/models/sqflite/employee.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // initial the database
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'employee.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      db.execute(
          '''CREATE TABLE employee(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, role TEXT NOT NULL, fromDate TEXT NOT NULL, toDate TEXT, status TEXT NOT NULL)''');
    });
  }

  // Load employees based on the status
  Future<List<Employee>> loadEmployeesData(String status) async {
    final db = await database;
    List<Map<String, dynamic>> employeesData =
    await db.query('employee', where: 'status=?', whereArgs: [status]);
    return employeesData.map((e) => Employee.fromJson(e)).toList();
  }

  // Add employee
  Future<int> addEmployee(Employee employee) async {
    final db = await database;
    return await db.insert('employee', employee.toJson());
  }

  // Edit employee
  Future<int> editEmployee(Employee employee) async {
    final db = await database;
    return await db.update('employee', employee.toJson(),
        where: 'id=?', whereArgs: [employee.id]);
  }

  // Delete employee
  Future<int> deleteEmployee(Employee employee) async {
    final db = await database;
    return db.delete('employee', where: 'id=?', whereArgs: [employee.id]);
  }
}