import 'package:employee_management/config/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:employee_management/bloc/employee_bloc/employee_bloc.dart';
import 'package:employee_management/bloc/employee_bloc/employee_event.dart';
import 'package:employee_management/bloc/employee_bloc/employee_state.dart';
import 'package:employee_management/config/app_constants.dart';
import 'package:employee_management/config/icon_constants.dart';
import 'package:employee_management/config/utils.dart';
import 'package:employee_management/data/models/employee.dart';
import 'package:employee_management/views/widgets/custom_date_picker.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({
    super.key,
    required this.action,
    this.employeeData,
  });
  final String action;
  final Employee? employeeData;

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate;
  final List<String> roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];
  double _empNameTextFieldHeight = 40.0;
  double _roleFieldHeight = 40.0;
  late EmployeeBloc _bloc;
  String _selectedFromDateValue = AppConstants.today;
  String _selectedToDateValue = AppConstants.noDate;

  @override
  void initState() {
    super.initState();
    // initialize the bloc
    _bloc = BlocProvider.of<EmployeeBloc>(context);

    //prefill employee data for edit action
    if (widget.employeeData != null) {
      _employeeNameController.text = widget.employeeData!.name!;
      _roleController.text = widget.employeeData!.role!;
      _fromDate = Utils.formatToDateTime(widget.employeeData!.fromDate!);
      _toDate = widget.employeeData!.toDate != null
          ? Utils.formatToDateTime(widget.employeeData!.toDate!)
          : null;
    }
    setState(() {
      _selectedFromDateValue =
          widget.action == AppConstants.editemployee ? "" : AppConstants.today;
      _selectedToDateValue =
          widget.action == AppConstants.editemployee ? "" : AppConstants.noDate;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // dispose controllers after use
    _employeeNameController.dispose();
    _roleController.dispose();
  }

  // Get 'from' date from CustomDatePicker widget
  void setSelectedFromDate(
          DateTime? fromDate, String selectedDateValue, String currentMonth) =>
      setState(() {
        _fromDate = fromDate;
        _selectedFromDateValue = selectedDateValue;
      });

  // Get 'to' date from CustomDatePicker widget
  void setSelectedToDate(
          DateTime? toDate, String selectedDateValue, String currentMonth) =>
      setState(() {
        _toDate = toDate;
        _selectedToDateValue = selectedDateValue;
      });

  // Build employee name text form field
  Padding get _buildEmployeeNameTextField => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SizedBox(
          height: _empNameTextFieldHeight,
          child: TextFormField(
            controller: _employeeNameController,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.text,
            onTap: () {
              // Remove error message when field is on focus
              _formKey.currentState?.reset();

              // Change height as per design when error messages are cleared
              setState(() {
                _empNameTextFieldHeight = 40;
                _roleFieldHeight = 40;
              });
            },
            validator: (value) {
              if (value!.trim().isEmpty ||
                  !(RegExp(r'^[A-Za-z ]{2,50}$')).hasMatch(value)) {
                setState(() {
                  _empNameTextFieldHeight = 65;
                });
                return value.trim().isEmpty
                    ? "**Please enter employee name"
                    : "**Please enter valid employee name";
              }
              setState(() {
                _empNameTextFieldHeight = 40;
              });
              return null;
            },
            decoration: InputDecoration(
              errorStyle: Theme.of(context).textTheme.labelSmall,
              contentPadding: EdgeInsets.zero,
              label: Text('Employee name',
                  style: TextStyle(color: Theme.of(context).hintColor)),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Image.asset(
                IconConstants.employeeName,
                height: 24,
                width: 24,
              ),
            ),
          )));

  // Build employee role text form field
  Padding get _buildRoleDropdown => Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: InkWell(
          onTap: () {
            // Hide keyboard
            FocusScope.of(context).unfocus();

            // Open roles bottom sheet
            _showRolesBottomSheet(context);
          },
          child: SizedBox(
            height: _roleFieldHeight,
            child: TextFormField(
              controller: _roleController,
              enabled: false,
              validator: (value) {
                if (_roleController.text.isEmpty) {
                  setState(() {
                    _roleFieldHeight = 65;
                  });
                  return "**Please select employee role";
                }
                setState(() {
                  _roleFieldHeight = 40;
                });
                return null;
              },
              style: Theme.of(context).textTheme.bodyMedium,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                hintText: 'Select role',
                errorStyle: Theme.of(context).textTheme.labelSmall,
                contentPadding: EdgeInsets.zero,
                prefixIcon: Image.asset(
                  IconConstants.role,
                  height: 24,
                  width: 24,
                ),
                suffixIcon: Image.asset(
                  IconConstants.downArrow,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          )));

  // Open roles bottom sheet
  void _showRolesBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => Container(
          decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
          height: 210,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
              itemCount: roles.length,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    child: Text(
                      roles[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      // Remove error message when field is on focus
                      _formKey.currentState!.reset();
                      _roleController.text = roles[index];

                      // Change height as per design when error messages are cleared
                      setState(() {
                        _roleFieldHeight = 40;
                      });

                      // Close roles bottom sheet
                      Navigator.pop(context);
                    },
                  )),
              separatorBuilder: (context, index) {
                return Divider(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .color!
                        .withOpacity(0.1));
              })));

  // Build dates section
  Column get _buildDateSection =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _buildFromDate),
          Image.asset(IconConstants.rightArrow),
          Expanded(child: _buildToDate),
        ]),
        if (!validateDates()) ...[
          Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("**Please select FROM date lesser than TO date",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: ColorConstants.error)))
        ]
      ]);

  // Show 'from' date CustomDatePicker
  Future<void> showCustomFromDatePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          isFromDate: true,
          setSelectedDate: setSelectedFromDate,
          initialDate: _fromDate!,
          selectedDateValue: _selectedFromDateValue,
          currentMonth:
              '${AppConstants.monthsLongAbbreviations[_fromDate!.month - 1]} ${_fromDate!.year}',
        );
      },
    );
  }

  // Show 'to' date CustomDatePicker
  Future<void> showCustomToDatePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          isFromDate: false,
          setSelectedDate: setSelectedToDate,
          initialDate: _toDate,
          selectedDateValue: _selectedToDateValue,
          currentMonth: _toDate == null
              ? '${AppConstants.monthsLongAbbreviations[DateTime.now().month - 1]} ${DateTime.now().year}'
              : '${AppConstants.monthsLongAbbreviations[(_toDate!).month - 1]} ${_toDate!.year}',
        );
      },
    );
  }

  // Build 'from' date field
  GestureDetector get _buildFromDate => GestureDetector(
        onTap: () async {
          // Hide keyboard
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 100));
          // Show calendar date picker
          showCustomFromDatePicker(context);
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Image.asset(IconConstants.calendar),
              const SizedBox(width: 8),
              Text(
                  Utils.compareDates(_fromDate!, DateTime.now())
                      ? 'Today'
                      : Utils.formatDate(_fromDate!),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );

  // Build 'to' date field
  GestureDetector get _buildToDate => GestureDetector(
        onTap: () async {
          // Hide keyboard
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 100));

          // Show calendar date picker
          showCustomToDatePicker(context);
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Image.asset(IconConstants.calendar),
              const SizedBox(width: 8),
              Text(
                  _toDate == null
                      ? 'No Date'
                      : Utils.compareDates(_toDate!, DateTime.now())
                          ? 'Today'
                          : Utils.formatDate(_toDate!),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: _toDate == null
                          ? Theme.of(context).hintColor
                          : ColorConstants.black)),
            ],
          ),
        ),
      );

  // Reset the form data
  void _resetData() {
    _employeeNameController.clear();
    _roleController.clear();
    _fromDate = DateTime.now();
    _toDate = null;
  }

  // Validate the 'from' and 'to' dates
  bool validateDates() {
    if (_toDate == null) {
      return true;
    }
    return _fromDate!.isBefore(_toDate!);
  }

  // Build buttons section at the bottom
  Container get _buildButtonsSection {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          10, 10, 10, keyboardHeight > 0 ? keyboardHeight + 10 : 10),
      decoration: BoxDecoration(
          border: Border(
              top:
                  BorderSide(width: 1, color: Theme.of(context).dividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                backgroundColor: Theme.of(context).primaryColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && validateDates()) {
                if (widget.action == AppConstants.addemployee) {
                  // Add employee event
                  _bloc.add(AddEmployee(Employee(
                    name: _employeeNameController.text,
                    role: _roleController.text,
                    fromDate: Utils.formatDate(_fromDate!),
                    toDate: _toDate == null ? null : Utils.formatDate(_toDate!),
                    status: _toDate != null
                        ? AppConstants.previous
                        : AppConstants.current,
                  )));
                } else {
                  // Edit employee event
                  _bloc.add(EditEmployee(Employee(
                    id: widget.employeeData!.id,
                    name: _employeeNameController.text,
                    role: _roleController.text,
                    fromDate: Utils.formatDate(_fromDate!),
                    toDate: _toDate == null ? null : Utils.formatDate(_toDate!),
                    status: _toDate != null
                        ? AppConstants.previous
                        : AppConstants.current,
                  )));
                }
                _resetData();
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Text(
              'Save',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: ColorConstants.white),
            ),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  Future _showDeleteDialog() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: ColorConstants.white,
              insetPadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.all(20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              content: const Text("Do you want to delete this employee?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.labelMedium,
                    )),
                TextButton(
                    onPressed: () {
                      _bloc.add(DeleteEmployee(widget.employeeData!));
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.labelMedium,
                    ))
              ],
            ));
  }

  // Show snackbar for user actions
  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      // Navigate back and load employees list with new changes
      Navigator.pop(context);
      _bloc.add(LoadEmployees());
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: ColorConstants.white,
            appBar: AppBar(
              backgroundColor: theme.primaryColor,
              automaticallyImplyLeading: false,
              leading: null,
              title: Text(
                widget.action == AppConstants.editemployee
                    ? "Edit Employee Details"
                    : "Add Employee Details",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.left,
              ),
              actions: widget.action == AppConstants.editemployee
                  ? [
                      InkWell(
                          onTap: () async {
                            // Show delete confirmation dialog box
                            await _showDeleteDialog();
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Image.asset(IconConstants.delete)))
                    ]
                  : null,
            ),
            bottomNavigationBar: _buildButtonsSection,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      _buildEmployeeNameTextField,
                      _buildRoleDropdown,
                      _buildDateSection,
                      if (state is EmployeesLoadingProgress)
                        Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor))
                    ],
                  )),
            ));
      },
      listener: (BuildContext context, EmployeeState state) {
        if (state is EmployeeAddedSuccess) {
          showSnackBar(context, "Employee data has been added");
        }
        if (state is EmployeeEditedSuccess) {
          showSnackBar(context, "Employee data has been edited");
        }
        if (state is EmployeeDeletedSuccess) {
          showSnackBar(context, "Employee data has been deleted");
        }
      },
    );
  }
}
