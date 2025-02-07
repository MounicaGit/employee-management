import 'package:employee_management/config/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:employee_management/bloc/employee_bloc/employee_event.dart';
import 'package:employee_management/bloc/employee_bloc/employee_state.dart';
import 'package:employee_management/data/database/database_helper.dart';
import 'package:hive/hive.dart';
import '../../data/models/sqflite/employee.dart';
import '../../data/models/hive/employee_web.dart';

/* Please note:
- Used SQFlite database as local storage for mobile devices only in this project (as SQFlite DB is less compatible with web apps)
- Used Hive database as local storage for web (Already wrote SQFlite DB code for mobile as I missed a point that I have to build app for web too,
  it is not much compatible for web so, used Hive for web app)
*/

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final Box<EmployeeWeb> employeeBox = Hive.box<EmployeeWeb>('employees');

  EmployeeBloc() : super(InitialEmployee()) {
    on<LoadEmployees>((event, emit) => _handleLoadEmployees(event, emit));
    on<AddEmployee>((event, emit) => _handleAddEmployees(event, emit));
    on<EditEmployee>((event, emit) => _handleEditEmployees(event, emit));
    on<DeleteEmployee>((event, emit) => _handleDeleteEmployees(event, emit));
  }

  // Load all employees
  void _handleLoadEmployees(LoadEmployees event, Emitter emit) async {
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (kIsWeb) {
        final List<EmployeeWeb> employees = employeeBox.values.toList();
        final List<Employee> employeesList =
            employees.map((emp) => Employee.fromJson(emp.toJson())).toList();
        final List<Employee> currentEmployees = employeesList
            .where((e) => e.status == AppConstants.current)
            .toList();
        final List<Employee> previousEmployees = employeesList
            .where((e) => e.status == AppConstants.previous)
            .toList();
        emit(EmployeesLoadedSuccess(currentEmployees, previousEmployees));
      } else {
        List<Employee> currentEmployeesList =
            await databaseHelper.loadEmployeesData(AppConstants.current);
        List<Employee> previousEmployeesList =
            await databaseHelper.loadEmployeesData(AppConstants.previous);
        emit(EmployeesLoadedSuccess(
            currentEmployeesList, previousEmployeesList));
      }
    } catch (e) {
      print("Exception while loading employees=> $e");
      emit(EmployeeLoadedFailed());
    }
  }

  // Add Employee
  void _handleAddEmployees(AddEmployee event, Emitter emit) async {
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (kIsWeb) {
        final convertedEmployee = EmployeeWeb.fromJson(event.employee.toJson());
        final generatedId = await employeeBox.add(convertedEmployee);
        convertedEmployee.id = generatedId;
        await convertedEmployee.save();
      } else {
        await databaseHelper.addEmployee(event.employee);
      }
      emit(EmployeeAddedSuccess());
    } catch (e) {
      print("Exception while adding employee=> $e");
      emit(EmployeeAddedFailed());
    }
  }

  // Edit existing employee
  void _handleEditEmployees(EditEmployee event, Emitter emit) async {
    try {
      emit(EmployeesLoadingProgress());
      await Future.delayed(const Duration(seconds: 1));
      if (kIsWeb) {
        Employee tempEmployee = event.employee;
        EmployeeWeb employee = employeeBox.get(event.employee.id)!;
        employee.name = tempEmployee.name;
        employee.role = tempEmployee.role;
        employee.fromDate = tempEmployee.fromDate;
        employee.toDate = tempEmployee.toDate;
        employee.status = tempEmployee.status;
        await employee.save();
      } else {
        await databaseHelper.editEmployee(event.employee);
      }
      emit(EmployeeEditedSuccess());
    } catch (e) {
      print("Exception while editing employee=> $e");
      emit(EmployeeEditedFailed());
    }
  }

  // Delete employee
  void _handleDeleteEmployees(DeleteEmployee event, Emitter emit) async {
    try {
      emit(EmployeesLoadingProgress());
      await Future.delayed(const Duration(seconds: 1));
      if (kIsWeb) {
        EmployeeWeb employee = employeeBox.get(event.employee.id)!;
        employee.delete();
      } else {
        await databaseHelper.deleteEmployee(event.employee);
      }

      // Deleted employee data is retained because user may undo the delete action from snack bar
      emit(EmployeeDeletedSuccess(event.employee));
    } catch (e) {
      print("Exception while deleting employees=> $e");
      emit(EmployeeDeletedFailed());
    }
  }
}
