// lib/employee.dart
import 'package:hive/hive.dart';

part 'employee_web.g.dart';

@HiveType(typeId: 0)
class EmployeeWeb extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String role;

  @HiveField(3)
  String fromDate;

  @HiveField(4)
  String? toDate;

  @HiveField(5)
  String status;

  EmployeeWeb({
    required this.id,
    required this.name,
    required this.role,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  // Convert the EmployeeWeb object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'fromDate': fromDate,
      'toDate': toDate,
      'status': status,
    };
  }

  // Convert a JSON map to an EmployeeWeb object.
  factory EmployeeWeb.fromJson(Map<String, dynamic> json) {
    return EmployeeWeb(
      id: json['id'] as int?,
      name: json['name'] as String,
      role: json['role'] as String,
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String?,
      status: json['status'] as String,
    );
  }
}
