import 'simple_scroll_view.dart';

class MinuteScrollView  extends SimpleScrollView<int> {


  MinuteScrollView({
    super.selectedData,
    required super.onDataChanged,
    super.locale,
    super.options,
    super.scrollViewOptions,
  }) : super( datas: [for (int i = 0; i < 60; i++) i],keyName: "minute", );

}