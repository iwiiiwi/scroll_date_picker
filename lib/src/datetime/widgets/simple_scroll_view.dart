


import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../../scroll_date_picker.dart';
import '../../utils/get_monthly_date.dart';
import '../../widgets/date_scroll_view.dart';
import '../scroll_datetime_picker.dart';

class SimpleScrollView<T> extends StatefulWidget{
  SimpleScrollView({
    Key? key,

      this.selectedData,
    required this.onDataChanged,
    required this.datas,
    String? keyName,
    Locale? locale,
    DatePickerOptions? options,
    ScrollViewDetailOptions? scrollViewOptions,
  })  :
        locale = locale ?? const Locale('en'),
        options = options ?? const DatePickerOptions(),
        scrollViewOptions =
            scrollViewOptions ?? const ScrollViewDetailOptions(),
  keyName=keyName??"simpleScroll",
        super(key: key);



  /// The currently selected date.
  final T? selectedData;
  final List<T> datas;
  final String keyName;



  /// On optional listener that's called when the centered item changes.
  final ValueChanged<T> onDataChanged;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// Set calendar language
  final Locale locale;

  /// A set that allows you to specify options related to ScrollView.
  final ScrollViewDetailOptions scrollViewOptions;
  @override
  State<SimpleScrollView<T>> createState() => _SimpleScrollViewState<T>();
}

class _SimpleScrollViewState<E> extends State<SimpleScrollView<E>> {
  /// A set that allows you to specify options related to ScrollView.
  /// This widget's year selection and animation state.
  late FixedExtentScrollController _scrollController;


  late Widget _scrollView;


  E? _selectedData;


  List<E> _datas = [];

  int get selectedIndex => (_selectedData==null || !_datas.contains(_selectedData))
      ? 0
      : _datas.indexOf(_selectedData!);



  E get selectedData {
    if (_scrollController.hasClients) {
      return _datas[_scrollController.selectedItem % _datas.length];
    }
    return _datas[0];
  }


  @override
  void initState() {
    super.initState();

    _datas =  widget.datas;

    _scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);

  }

  @override
  void didUpdateWidget(covariant SimpleScrollView<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedData != widget.selectedData) {
      _selectedData = widget.selectedData;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateToItem(selectedIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initDateScrollView() {

    _scrollView = DateScrollView(
        key:   Key(widget.keyName),
        dates: _datas,
        controller: _scrollController,
        options: widget.options,
        scrollViewOptions: widget.scrollViewOptions,
        selectedIndex: selectedIndex,
        locale: widget.locale,
        onTap: (int index) => _scrollController.jumpToItem(index),
        onChanged: (index) {
          _onDataChanged(index);
        });

  }


  void _onDataChanged(int index) {
    _selectedData = _datas[index];
    widget.onDataChanged(_selectedData!);
  }

  List<Widget> _getScrollDataPicker() {
    _initDateScrollView();
      return [_scrollView];
    }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _getScrollDataPicker(),
    );
  }
}