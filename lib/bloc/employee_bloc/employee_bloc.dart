import 'package:employee_management/config/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:employee_management/bloc/employee_bloc/employee_event.dart';
import 'package:employee_management/bloc/employee_bloc/employee_state.dart';
import 'package:employee_management/data/database/database_helper.dart';
import '../../data/models/employee.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  EmployeeBloc() : super(InitialEmployee()) {
    on<LoadEmployees>((event, emit) => _handleLoadEmployees(event, emit));
    on<AddEmployee>((event, emit) => _handleAddEmployees(event, emit));
    on<EditEmployee>((event, emit) => _handleEditEmployees(event, emit));
    on<DeleteEmployee>((event, emit) => _handleDeleteEmployees(event, emit));
  }

  // Load all employees
  void _handleLoadEmployees(LoadEmployees event, Emitter emit) async {
    List<Employee> currentEmployeesList =
        await databaseHelper.loadEmployeesData(AppConstants.current);
    List<Employee> previousEmployeesList =
        await databaseHelper.loadEmployeesData(AppConstants.previous);
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    emit(EmployeesLoadedSuccess(currentEmployeesList, previousEmployeesList));
  }

  // Add Employee
  void _handleAddEmployees(AddEmployee event, Emitter emit) async {
    int result = await databaseHelper.addEmployee(event.employee);
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    if (result > 0) {
      emit(EmployeeAddedSuccess());
    } else {
      emit(EmployeeAddedFailed());
    }
  }

  // Edit existing employee
  void _handleEditEmployees(EditEmployee event, Emitter emit) async {
    int result = await databaseHelper.editEmployee(event.employee);
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    if (result > 0) {
      emit(EmployeeEditedSuccess());
    } else {
      emit(EmployeeEditedFailed());
    }
  }

  // Delete employee
  void _handleDeleteEmployees(DeleteEmployee event, Emitter emit) async {
    int result = await databaseHelper.deleteEmployee(event.employee);
    emit(EmployeesLoadingProgress());
    await Future.delayed(const Duration(seconds: 1));
    if (result > 0) {
      // Deleted employee data is retained because user may undo the delete action from snack bar
      emit(EmployeeDeletedSuccess(event.employee));
    } else {
      emit(EmployeeDeletedFailed());
    }
  }
}
