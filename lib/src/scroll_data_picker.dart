import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import 'utils/get_monthly_date.dart';
import 'widgets/data_scroll_view.dart';

class ScrollDataPicker extends StatefulWidget {
  ScrollDataPicker({
    Key? key,
    this.viewType,
    this.selectedDayIndex=0,
    this.selectedMonthIndex=0,
    this.selectedYearIndex=0,
    DatePickerOptions? options,
    DatePickerScrollViewOptions? scrollViewOptions,
    List<String>? yearValues,
    List<String>? monthValues,
    List<String>? dayValues,
    this.onYearIndexChanged,
    this.onMonthIndexChanged,
    this.onDayIndexChanged,
    this.indicator,
  })  :
      yearValues=yearValues??[],
      monthValues=monthValues??[],
      dayValues=dayValues??[],
        options = options ?? const DatePickerOptions(),
        scrollViewOptions =
            scrollViewOptions ?? const DatePickerScrollViewOptions(),
        super(key: key);

  /// A list that allows you to specify the type of date view.
  /// And also the order of the viewType in list is the order of the date view.
  /// If this list is null, the default order of locale is set.
  /// TODO("Satoshi"): Specify the type of date view visible.
  final List<DatePickerViewType>? viewType;

  /// The currently selected date.
  final int selectedYearIndex;
  final int selectedMonthIndex;
  final int selectedDayIndex;

  final List<String> yearValues;
  final List<String> monthValues;
  final List<String> dayValues;


  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int>? onYearIndexChanged;
  final ValueChanged<int>? onMonthIndexChanged;
  final ValueChanged<int>? onDayIndexChanged;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;


  /// A set that allows you to specify options related to ScrollView.
  final DatePickerScrollViewOptions scrollViewOptions;

  /// Indicator displayed in the center of the ScrollDatePicker
  final Widget? indicator;

  @override
  State<ScrollDataPicker> createState() => _ScrollDataPickerState();
}

class _ScrollDataPickerState extends State<ScrollDataPicker> {
  /// This widget's year selection and animation state.
  late FixedExtentScrollController _yearController;

  /// This widget's month selection and animation state.
  late FixedExtentScrollController _monthController;

  /// This widget's day selection and animation state.
  late FixedExtentScrollController _dayController;

  late Widget _yearScrollView;
  late Widget _monthScrollView;
  late Widget _dayScrollView;

  late int _selectedYearIndex;
  late int _selectedMonthIndex;
  late int _selectedDayIndex;
  bool isYearScrollable = true;
  bool isMonthScrollable = true;
  List<String> _years = [];
  List<String> _months = [];
  List<String> _days = [];

  int get selectedYearIndex => _selectedYearIndex;

  int get selectedMonthIndex => _selectedMonthIndex;

  int get selectedDayIndex => _selectedDayIndex;



  @override
  void initState() {
    super.initState();
     _selectedYearIndex=widget.selectedYearIndex;
     _selectedMonthIndex=widget.selectedMonthIndex;
     _selectedDayIndex=widget.selectedDayIndex;
    _yearController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    _monthController =
        FixedExtentScrollController(initialItem: selectedMonthIndex);
    _dayController = FixedExtentScrollController(initialItem: selectedDayIndex);
    _years=widget.yearValues;
    _months=widget.monthValues;
    _days=widget.dayValues;
  }

  @override
  void didUpdateWidget(covariant ScrollDataPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDayIndex != widget.selectedDayIndex || _selectedMonthIndex != widget.selectedMonthIndex || _selectedYearIndex != widget.selectedYearIndex) {
    //   _selectedDate = widget.selectedDate;
    //   isYearScrollable = false;
    //   isMonthScrollable = false;
      _selectedYearIndex=widget.selectedYearIndex;
      _selectedMonthIndex=widget.selectedMonthIndex;
      _selectedDayIndex=widget.selectedDayIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _yearController.animateToItem(selectedYearIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
        _monthController.animateToItem(selectedMonthIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
        _dayController.animateToItem(selectedDayIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
      });
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initDateScrollView() {
    _yearScrollView = DataScrollView(
        key: const Key("year"),
        datas: _years,
        controller: _yearController,
        options: widget.options,
        scrollViewOptions: widget.scrollViewOptions.year,
        selectedIndex: selectedYearIndex,
        onTap: (int index) => _yearController.jumpToItem(index),
        onChanged: (_) {
           widget.onYearIndexChanged?.call(_);
        });
    _monthScrollView = DataScrollView(
      key: const Key("month"),
      datas: _months,
      controller: _monthController,
      options: widget.options,
      scrollViewOptions: widget.scrollViewOptions.month,
      selectedIndex: selectedMonthIndex,
      onTap: (int index) => _monthController.jumpToItem(index),
      onChanged: (_) {
        widget.onMonthIndexChanged?.call(_);
      },
    );
    _dayScrollView = DataScrollView(
      key: const Key("day"),
      datas: _days,
      controller: _dayController,
      options: widget.options,
      scrollViewOptions: widget.scrollViewOptions.day,
      selectedIndex: selectedDayIndex,
      onTap: (int index) => _dayController.jumpToItem(index),
      onChanged: (_) {
        widget.onDayIndexChanged?.call(_);
      },
    );
  }


  List<Widget> _getScrollDatePicker() {
    _initDateScrollView();

    // set order of scroll view
    if (widget.viewType?.isNotEmpty ?? false) {
      final viewList = <Widget>[];

      for (var view in widget.viewType!) {
        switch (view) {
          case DatePickerViewType.year:
            viewList.add(_yearScrollView);
            break;
          case DatePickerViewType.month:
            viewList.add(_monthScrollView);
            break;
          case DatePickerViewType.day:
            viewList.add(_dayScrollView);
            break;
          case DatePickerViewType.hour:
            // TODO: Handle this case.
          case DatePickerViewType.minute:
            // TODO: Handle this case.
          case DatePickerViewType.second:
            // TODO: Handle this case.
        }
      }

      return viewList;
    }


        return [_monthScrollView, _dayScrollView, _yearScrollView];

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: widget.scrollViewOptions.mainAxisAlignment,
          crossAxisAlignment: widget.scrollViewOptions.crossAxisAlignment,
          children: _getScrollDatePicker(),
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
