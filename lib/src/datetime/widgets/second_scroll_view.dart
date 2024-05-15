import 'package:flutter/cupertino.dart';

import '../../../scroll_date_picker.dart';
import '../../widgets/date_scroll_view.dart';
import 'simple_scroll_view.dart';


class SecondScrollView  extends SimpleScrollView<int> {


  SecondScrollView({
    super.selectedData,
    required super.onDataChanged,
    super.locale,
    super.options,
    super.scrollViewOptions,
  }) : super( datas: [for (int i = 0; i < 60; i++) i],keyName: "second", );

}
