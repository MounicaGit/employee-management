import 'package:employee_management/config/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../config/color_constants.dart';
import '../../config/icon_constants.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.setSelectedDate,
    required this.isFromDate,
    required this.initialDate,
    required this.selectedDateValue,
    required this.currentMonth,
  });
  final Function(DateTime?, String, String) setSelectedDate;
  final bool isFromDate;
  final DateTime? initialDate;
  final String currentMonth;
  final String selectedDateValue;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late String _selectedDateValue;
  late DateTime? _tempSelectedDate;
  late DateTime? _currentDisplayedDate;
  late String _currentMonth;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentDisplayedDate = widget.initialDate;
      _selectedDateValue = widget.selectedDateValue;
      _tempSelectedDate = widget.initialDate;
      _currentMonth = widget.currentMonth;
    });
  }

  // Change months when custom header arrow button clicked
  DateTime modifyMonths(DateTime original, int monthsToAdd) {
    int totalMonths = original.year * 12 + original.month - 1 + monthsToAdd;
    int newYear = totalMonths ~/ 12;
    int newMonth = totalMonths % 12 + 1;
    int newDay = original.day;
    final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfNewMonth) {
      newDay = lastDayOfNewMonth;
    }
    return DateTime(newYear, newMonth, newDay);
  }

  // Build calender buttons section at the bottom
  Container get _buildCalendarButtonsSection {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          5, 10, 10, keyboardHeight > 0 ? keyboardHeight + 10 : 10),
      decoration: BoxDecoration(
          border: Border(
              top:
                  BorderSide(width: 1, color: Theme.of(context).dividerColor))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(IconConstants.calendar),
            const SizedBox(width: 8),
            Text(
              _tempSelectedDate == null
                  ? 'No Date'
                  : Utils.formatDate(DateTime(_tempSelectedDate!.year,
                      _tempSelectedDate!.month, _tempSelectedDate!.day)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
                widget.setSelectedDate(
                    _tempSelectedDate, _selectedDateValue, _currentMonth);
                Navigator.pop(context);
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).textTheme.headlineMedium!.color),
              ),
            ),
          ],
        )
      ]),
    );
  }

  // Get week days to change the selected date
  DateTime getNextWeekday(int targetWeekday, StateSetter setStateDialog) {
    final date = widget.initialDate ?? now;
    if (targetWeekday == 0) {
      return date.add(const Duration(days: 7));
    }
    int currentWeekday = date.weekday;
    int daysToAdd = (targetWeekday - currentWeekday + 7) % 7;
    if (daysToAdd == 0) {
      daysToAdd = 7;
    }
    return date.add(Duration(days: daysToAdd));
  }

  // Show alert when dates exceeds for custom button clicks
  Future _showDatesExceedDialog() {
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
              content: const Text("Dates cannot exceed today's date"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.labelMedium,
                    ))
              ],
            ));
  }

  // Build custom date buttons at the top
  Expanded _buildCustomDateButton(StateSetter setStateDialog,
      DateTime? tempSelectedDate, String selectedDateValue) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          if (!widget.isFromDate) {
            if (tempSelectedDate == null ||
                Utils.compareDates(tempSelectedDate, now)) {
              setStateDialog(() {
                _tempSelectedDate = tempSelectedDate;
                _currentDisplayedDate = tempSelectedDate;
                _selectedDateValue = selectedDateValue;
                if (tempSelectedDate != null) {
                  _currentMonth =
                      '${AppConstants.monthsLongAbbreviations[(tempSelectedDate.month ?? 1) - 1]} ${tempSelectedDate.year}';
                }
              });
            }
          } else {
            if (tempSelectedDate != null) {
              // print('days=> ${now.difference(tempSelectedDate).inDays}');
              if (now.difference(tempSelectedDate).inDays >= 0) {
                setStateDialog(() {
                  _tempSelectedDate = tempSelectedDate;
                  _currentDisplayedDate = tempSelectedDate;
                  _selectedDateValue = selectedDateValue;
                  _currentMonth =
                      '${AppConstants.monthsLongAbbreviations[(tempSelectedDate.month ?? 1) - 1]} ${tempSelectedDate.year}';
                });
              } else {
                await _showDatesExceedDialog();
              }
            } else {
              await _showDatesExceedDialog();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _selectedDateValue == selectedDateValue
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          selectedDateValue,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: _selectedDateValue == selectedDateValue
                    ? Theme.of(context).textTheme.headlineMedium!.color
                    : Theme.of(context).textTheme.labelMedium!.color,
              ),
        ),
      ),
    );
  }

  // Build 'from' date button section at the top
  Column _buildFromDateButtonsSection(setStateDialog) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Today
          Row(
            children: [
              _buildCustomDateButton(setStateDialog, now, AppConstants.today),
              //Next Monday
              const SizedBox(width: 10),
              _buildCustomDateButton(
                setStateDialog,
                getNextWeekday(DateTime.monday, setStateDialog),
                AppConstants.nextMonday,
              ),
            ],
          ),
          if (kIsWeb) const SizedBox(height: 10),
          //Next Tuesday
          Row(
            children: [
              _buildCustomDateButton(
                setStateDialog,
                getNextWeekday(DateTime.tuesday, setStateDialog),
                AppConstants.nextTuesday,
              ),
              const SizedBox(width: 10),
              //Next Week
              _buildCustomDateButton(setStateDialog,
                  getNextWeekday(0, setStateDialog), AppConstants.afterOneWeek),
            ],
          ),
        ],
      );

  // Build 'to' date button section at the top
  Row _buildToDateButtonsSection(setStateDialog) => Row(
        children: [
          _buildCustomDateButton(setStateDialog, null, AppConstants.noDate),
          const SizedBox(width: 10),
          _buildCustomDateButton(setStateDialog, now, AppConstants.today),
        ],
      );

  // Build calendar date picker widget
  CalendarDatePicker _buildCalendarSection(setStateDialog) =>
      CalendarDatePicker(
        key: ValueKey(_currentDisplayedDate),
        initialDate: _currentDisplayedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(now.year, now.month, now.day),
        onDateChanged: (date) {
          setStateDialog(() {
            _tempSelectedDate = date;
            _selectedDateValue = "";
          });
        },
      );

  // Build custom header section
  Container _buildHeaderSection(setStateDialog) => Container(
      height: 35,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
            onTap: () {
              // Navigate the calendar to previous months
              setStateDialog(() {
                _currentDisplayedDate = modifyMonths(
                    _currentDisplayedDate == null
                        ? now
                        : _currentDisplayedDate!,
                    -1);
                // _tempSelectedDate = _currentDisplayedDate!;
              });
              setStateDialog(() {
                _currentMonth =
                    '${AppConstants.monthsLongAbbreviations[_currentDisplayedDate!.month - 1]} ${_currentDisplayedDate!.year}';
              });
            },
            child: Image.asset(IconConstants.leftPointer)),
        const SizedBox(width: 10),
        Text(
          _currentMonth,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(width: 10),
        InkWell(
            // Navigate the calendar to next months
            onTap: ((_currentDisplayedDate ?? now).year < now.year ||
                    ((_currentDisplayedDate ?? now).year == now.year &&
                        (_currentDisplayedDate ?? now).month < now.month))
                ? () {
                    final DateTime modifiedDate = modifyMonths(
                        _currentDisplayedDate == null
                            ? now
                            : _currentDisplayedDate!,
                        1);
                    setStateDialog(() {
                      _currentDisplayedDate = DateTime(
                          modifiedDate.year, modifiedDate.month, now.day);
                    });
                    setStateDialog(() {
                      _currentMonth =
                          '${AppConstants.monthsLongAbbreviations[_currentDisplayedDate!.month - 1]} ${_currentDisplayedDate!.year}';
                    });
                  }
                : null,
            child: Image.asset(
              IconConstants.rightPointer,
              color: ((_currentDisplayedDate ?? now).year < now.year ||
                      ((_currentDisplayedDate ?? now).year == now.year &&
                          (_currentDisplayedDate ?? now).month < now.month))
                  ? Colors.grey
                  : Colors.grey.withOpacity(0.5),
            )),
      ]));

  // Build calendar body
  Container _buildBody(setStateDialog) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            widget.isFromDate
                ? _buildFromDateButtonsSection(setStateDialog)
                : _buildToDateButtonsSection(setStateDialog),
            const SizedBox(height: 10),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
                datePickerTheme: DatePickerThemeData(
                    headerBackgroundColor: Colors.grey[100],
                    headerForegroundColor: Colors.transparent,
                    headerHeadlineStyle: const TextStyle(fontSize: 0),
                    headerHelpStyle: const TextStyle(fontSize: 0),
                    todayBorder: _selectedDateValue == AppConstants.noDate
                        ? BorderSide.none
                        : const BorderSide(width: 1)),
              ),
              child: Stack(children: [
                _buildCalendarSection(setStateDialog),
                _buildHeaderSection(setStateDialog)
              ]),
            ),
            const SizedBox(height: 10),
            _buildCalendarButtonsSection,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return Dialog(
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth:
                        kIsWeb ? 500 : MediaQuery.of(context).size.width - 40,
                    maxWidth:
                        kIsWeb ? 500 : MediaQuery.of(context).size.width - 40,
                    minHeight: widget.isFromDate
                        ? kIsWeb
                            ? 500
                            : 300
                        : kIsWeb
                            ? 480
                            : 340),
                child: _buildBody(setStateDialog)));
      },
    );
  }
}
