import '../../data/models/sqflite/employee.dart';

abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class EditEmployee extends EmployeeEvent {
  final Employee employee;
  EditEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final Employee employee;
  DeleteEmployee(this.employee);
}
