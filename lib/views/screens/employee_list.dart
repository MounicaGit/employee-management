import 'package:employee_management/config/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_management/bloc/employee_bloc/employee_event.dart';
import 'package:employee_management/data/models/sqflite/employee.dart';

import 'package:employee_management/config/app_constants.dart';
import 'package:employee_management/config/icon_constants.dart';
import 'package:employee_management/views/screens/employee_form.dart';
import '../../bloc/employee_bloc/employee_bloc.dart';
import '../../bloc/employee_bloc/employee_state.dart';
import '../../config/image_constants.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  late EmployeeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<EmployeeBloc>(context);
    // Load employees initially
    _bloc.add(LoadEmployees());
  }

  //  Build each Employees section
  Column _buildEmployeesSection(
      String title, List<Employee> employeesList, EmployeeState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          )),
      Container(
          color: ColorConstants.white,
          child: ListView.separated(
              itemCount: employeesList.length,
              separatorBuilder: (context, index) {
                return Divider(color: Theme.of(context).dividerColor);
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final employeeFromDate =
                    employeesList[index].fromDate!.split(" ");
                final String formatedFromDate =
                    "${employeeFromDate[0]} ${employeeFromDate[1]}, ${employeeFromDate[2]}";
                String formattedToDate = '';
                if (employeesList[index].status == AppConstants.previous) {
                  final employeeToDate =
                      employeesList[index].toDate!.split(" ");
                  formattedToDate =
                      "${employeeToDate[0]} ${employeeToDate[1]}, ${employeeToDate[2]}";
                }

                return InkWell(
                    onTap: () {
                      // Navigate to employee form to edit the employee details
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: context.read<EmployeeBloc>(),
                              child: EmployeeForm(
                                action: AppConstants.editemployee,
                                employeeData: employeesList[index],
                              ))));
                    },
                    child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          _bloc.add(DeleteEmployee(employeesList[index]));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Employee data has been deleted'),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    _bloc
                                        .add(AddEmployee(employeesList[index]));
                                    _bloc.add(LoadEmployees());
                                  }),
                            ),
                          );
                          _bloc.add(LoadEmployees());
                        },
                        background: Container(
                            color: const Color(0xFFF34642),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(IconConstants.delete)),
                        direction: DismissDirection.endToStart,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15,
                                index == employeesList.length - 1 ? 15 : 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employeesList[index].name!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  employeesList[index].role!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 5),
                                Row(children: [
                                  Text(
                                    '${employeesList[index].status == AppConstants.current ? 'From ' : ''}$formatedFromDate',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (employeesList[index].status ==
                                      AppConstants.previous)
                                    Text(
                                      " - $formattedToDate",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                ])
                              ],
                            ))));
              }))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (BuildContext context, EmployeeState state) {
        if (state is EmployeesLoadedSuccess) {
          bool isNotEmptyLists = state.currentEmployees.isNotEmpty ||
              state.previousEmployees.isNotEmpty;
          return Scaffold(
              backgroundColor: Theme.of(context).dividerColor,
              appBar: AppBar(
                backgroundColor: theme.primaryColor,
                title: Text(
                  "Employee List",
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: isNotEmptyLists
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      if (isNotEmptyLists)
                        Text(
                          "Swipe left to delete",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      FloatingActionButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                    value: context.read<EmployeeBloc>(),
                                    child: const EmployeeForm(
                                      action: AppConstants.addemployee,
                                    )))),
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Image.asset(IconConstants.add),
                      )
                    ],
                  )),
              body: isNotEmptyLists
                  ? SingleChildScrollView(
                      child: Column(
                      children: [
                        if (state.currentEmployees.isNotEmpty)
                          _buildEmployeesSection("Current employees",
                              state.currentEmployees, state),
                        if (state.previousEmployees.isNotEmpty)
                          _buildEmployeesSection("Previous employees",
                              state.previousEmployees, state)
                      ],
                    ))
                  : Center(child: Image.asset(ImageConstants.emptyEmployee)));
        } else if (state is EmployeesLoadingProgress) {
          return Container(
              color: ColorConstants.white,
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
