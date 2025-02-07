import '../../data/models/employee.dart';

abstract class EmployeeState {}

class InitialEmployee extends EmployeeState {}

class EmployeeAddedSuccess extends EmployeeState {}

class EmployeeDeletedSuccess extends EmployeeState {
  final Employee employee;
  EmployeeDeletedSuccess(this.employee);
}

class EmployeeEditedSuccess extends EmployeeState {}

class EmployeesLoadedSuccess extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;
  EmployeesLoadedSuccess(this.currentEmployees, this.previousEmployees);
}

class EmployeeAddedFailed extends EmployeeState {}

class EmployeeDeletedFailed extends EmployeeState {}

class EmployeeEditedFailed extends EmployeeState {}

class EmployeeLoadedFailed extends EmployeeState {}

class EmployeesLoadingProgress extends EmployeeState {}
