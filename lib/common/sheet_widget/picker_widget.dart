import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final DateTimePickerNotifier? dateTimePickerNotifier;
  final bool showText;
  final bool showDay;
  final int lastYear;
  const DateTimePicker({
    super.key,
    this.initialDateTime,
    this.onDateTimeChanged,
    this.dateTimePickerNotifier,
    this.showText = false,
    this.showDay = true,
    this.lastYear = 1,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  final DateTime _currentDate = DateTime.now();
  int _startYear = 2025;

   bool showDay = true;

  @override
  void initState() {
    super.initState();

    showDay = widget.showDay;
    final initialDate = widget.initialDateTime ?? _currentDate;
    _selectedYear = initialDate.year;
    _selectedMonth = initialDate.month;
    _selectedDay = initialDate.day;

    _startYear = _currentDate.year - widget.lastYear;

    _yearController =
        FixedExtentScrollController(initialItem: _selectedYear - _startYear);
    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);

    widget.dateTimePickerNotifier?.addListener(_onController);

  }
  _onController() {
    if (mounted) {
      if (widget.dateTimePickerNotifier?.type == "jumpTime") {
        jumpToDate(widget.dateTimePickerNotifier?.jTime??DateTime.now());
      }
      if (widget.dateTimePickerNotifier?.type == "changeTimeType") {
        showDay = widget.dateTimePickerNotifier!.showDay;
        setState(() {});
      }
    }
  }


  void jumpToDate(DateTime date) {
    final years = getYears();
    final yearIndex = years.indexOf(date.year);
    if (yearIndex != -1) {
      _yearController.jumpToItem(yearIndex);
      _selectedYear = date.year;
    }

    final months = getMonths();
    final monthIndex = months.indexOf(date.month);
    if (monthIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _monthController.jumpToItem(monthIndex);
      });
      _selectedMonth = date.month;
    }

    final days = getDays();
    final dayIndex = days.indexOf(date.day);
    if (dayIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dayController.jumpToItem(dayIndex);
      });
      _selectedDay = date.day;
    }

    _notifyDateTimeChanged();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  List<int> getYears() {
    return List.generate(
        _currentDate.year - _startYear + 1, (index) => _startYear + index);
  }

  List<int> getMonths() {
    int maxMonth = 12;
    if (_selectedYear == _currentDate.year) {
      maxMonth = _currentDate.month;
    }
    return List.generate(maxMonth, (index) => index + 1);
  }

  List<int> getDays() {
    int maxDay;
    if (_selectedYear == _currentDate.year &&
        _selectedMonth == _currentDate.month) {
      maxDay = _currentDate.day;
    } else {
      maxDay = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    }
    return List.generate(maxDay, (index) => index + 1);
  }

  void _onYearSelected(int index) {
    final years = getYears();
    setState(() {
      _selectedYear = years[index];
      // 检查月份是否超出范围
      final months = getMonths();
      if (_selectedMonth > months.length) {
        _selectedMonth = months.last;
        _monthController.jumpToItem(_selectedMonth - 1);
      }
      // 检查日期是否超出范围
      final days = getDays();
      if (_selectedDay > days.length) {
        _selectedDay = days.last;
        _dayController.jumpToItem(_selectedDay - 1);
      }
    });
    _notifyDateTimeChanged();
  }

  void _onMonthSelected(int index) {
    setState(() {
      _selectedMonth = index + 1;
      // 检查日期是否超出范围
      final days = getDays();
      if (_selectedDay > days.length) {
        _selectedDay = days.last;
        _dayController.jumpToItem(_selectedDay - 1);
      }
    });
    _notifyDateTimeChanged();
  }

  void _onDaySelected(int index) {
    setState(() {
      _selectedDay = index + 1;
    });
    _notifyDateTimeChanged();
  }

  void _notifyDateTimeChanged() {
    if (widget.onDateTimeChanged != null) {
      widget.onDateTimeChanged!(
          DateTime(_selectedYear, _selectedMonth, _selectedDay));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: _yearController,
            itemExtent: 42.w,
            onSelectedItemChanged: _onYearSelected,
            // selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            //   capStartEdge: false,
            //   capEndEdge: false,
            // ),
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.w, color: const Color(0xFFE7E7E7)),
                  bottom: BorderSide(
                      width: 1.w, color: const Color(0xFFE7E7E7)), // 下边框
                ),
              ),
            ),
            children: getYears().map((year) {
              return Center(
                child: Text(
                  widget.showText?'$year年':year.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // 月选择器
        Expanded(
          child: CupertinoPicker(
            scrollController: _monthController,
            itemExtent: 42.w,
            onSelectedItemChanged: _onMonthSelected,
            // selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            //   capStartEdge: false,
            //   capEndEdge: false,
            // ),
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.w, color: const Color(0xFFE7E7E7)),
                  bottom: BorderSide(
                      width: 1.w, color: const Color(0xFFE7E7E7)), // 下边框
                ),
              ),
            ),
            children: getMonths().map((month) {
              return Center(
                child: Text(
                  widget.showText?'$month月':month.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // 日选择器
        showDay? Expanded(
          child: CupertinoPicker(
            scrollController: _dayController,
            itemExtent: 42.w,
            onSelectedItemChanged: _onDaySelected,
            // selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            //   capStartEdge: false,
            //   capEndEdge: false,
            // ),
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.w, color: const Color(0xFFE7E7E7)),
                  bottom: BorderSide(
                      width: 1.w, color: const Color(0xFFE7E7E7)), // 下边框
                ),
              ),
            ),
            children: getDays().map((day) {
              return Center(
                child: Text(
                  widget.showText?'$day日':day.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ):SizedBox.shrink(),
      ],
    );
  }
}


class DateTimePickerNotifier extends ChangeNotifier {

  String type = '';

  DateTime? jTime;
  jumpTime(DateTime t) {
    type = 'jumpTime';
    jTime = t;
    notifyListeners();
  }

  bool showDay = true;
  changeTimeType(bool show){
    type = 'changeTimeType';
    showDay = show;
    notifyListeners();
  }

}

