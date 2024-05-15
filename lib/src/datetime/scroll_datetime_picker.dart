import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:scroll_date_picker/src/datetime/widgets/hour_scroll_view.dart';
import 'package:scroll_date_picker/src/datetime/widgets/minute_scroll_view.dart';
import 'package:scroll_date_picker/src/datetime/widgets/second_scroll_view.dart';
import 'package:scroll_date_picker/src/datetime/widgets/simple_scroll_view.dart';
import 'package:scroll_date_picker/src/datetime/widgets/year_month_day_scroll_view.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import '../utils/get_monthly_date.dart';

class ScrollDateTimePicker extends StatefulWidget {
  ScrollDateTimePicker({
    Key? key,
    required this.viewType,
    required this.selectedDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    required this.onDateTimeChanged,
    Locale? locale,
    DatePickerOptions? options,
    DatePickerScrollViewOptions? scrollViewOptions,
    this.indicator,
  })  : minimumDate = minimumDate ?? DateTime(1960, 1, 1),
        maximumDate = maximumDate ?? DateTime.now(),
        locale = locale ?? const Locale('en'),
        options = options ?? const DatePickerOptions(),
        scrollViewOptions =
            scrollViewOptions ?? const DatePickerScrollViewOptions(),
        super(key: key);

  /// A list that allows you to specify the type of date view.
  /// And also the order of the viewType in list is the order of the date view.
  /// If this list is null, the default order of locale is set.
  /// TODO("Satoshi"): Specify the type of date view visible.
  final List<DatePickerViewType> viewType;

  /// The currently selected date.
  final DateTime selectedDate;

  /// Minimum year that the picker can be scrolled
  final DateTime minimumDate;

  /// Maximum year that the picker can be scrolled
  final DateTime maximumDate;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// Set calendar language
  final Locale locale;

  /// A set that allows you to specify options related to ScrollView.
  final DatePickerScrollViewOptions scrollViewOptions;

  /// Indicator displayed in the center of the ScrollDatePicker
  final Widget? indicator;

  @override
  State<ScrollDateTimePicker> createState() => _ScrollDateTimePickerState();
}

class _ScrollDateTimePickerState extends State<ScrollDateTimePicker> {

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate.isAfter(widget.maximumDate) ||
        widget.selectedDate.isBefore(widget.minimumDate)
        ? DateTime.now()
        : widget.selectedDate;
  }


  @override
  void didUpdateWidget(covariant ScrollDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  void _onHourChanged(int  hour) {
    _selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,hour,_selectedDate.minute,_selectedDate.second);
    widget.onDateTimeChanged(_selectedDate);
  }
  void _onMinuteChanged(  int minute) {
    _selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,_selectedDate.hour, minute,_selectedDate.second);
    widget.onDateTimeChanged(_selectedDate);
  }
  void _onSecondChanged(  int second) {
    _selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,_selectedDate.hour,_selectedDate.minute,second);
    widget.onDateTimeChanged(_selectedDate);
  }


  void _onDateTimeChanged(DateTime date) {
    _selectedDate =
        DateTime(date.year, date.month, date.day,_selectedDate.hour,_selectedDate.minute,_selectedDate.second);
    widget.onDateTimeChanged(_selectedDate);
  }


  List<Widget> _getScrollDateTimePicker() {
    final viewList = <Widget>[];
    if (widget.viewType.contains(DatePickerViewType.year)  ||
        widget.viewType.contains(DatePickerViewType.month)  ||
        widget.viewType.contains(DatePickerViewType.day)  ) {
      var yearMonthDayView = YearMonthDayScrollView(
        selectedDate: _selectedDate,
        onDateTimeChanged: (DateTime date){
          _onDateTimeChanged(date);
        },
        viewType: widget.viewType,
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
        locale: widget.locale,
        options: widget.options,
        scrollViewOptions: widget.scrollViewOptions,
      );
      viewList.add(yearMonthDayView);
    }
    if(widget.viewType.contains(DatePickerViewType.hour)){
      viewList.add(HourScrollView(onDataChanged: (  value){
            _onHourChanged(value);
      },   selectedData: _selectedDate.hour,scrollViewOptions: widget.scrollViewOptions.hour,));
    }
    if(widget.viewType.contains(DatePickerViewType.minute)){
      viewList.add(MinuteScrollView(onDataChanged: (  value){
            _onMinuteChanged(value);
      },   selectedData: _selectedDate.minute,scrollViewOptions: widget.scrollViewOptions.minute,));
    }
    if(widget.viewType.contains(DatePickerViewType.second)){
      viewList.add(SecondScrollView(onDataChanged: (  value){
            _onSecondChanged(value);
      },   selectedData: _selectedDate.second,scrollViewOptions: widget.scrollViewOptions.second));
    }
    return viewList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: widget.scrollViewOptions.mainAxisAlignment,
          crossAxisAlignment: widget.scrollViewOptions.crossAxisAlignment,
          children: _getScrollDateTimePicker(),
        ),
        // Date Picker Indicator
        IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.options.backgroundColor,
                        widget.options.backgroundColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              widget.indicator ??
                  Container(
                    height: widget.options.itemExtent,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.options.backgroundColor.withOpacity(0.7),
                        widget.options.backgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
