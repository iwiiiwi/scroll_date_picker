import 'package:scroll_date_picker/src/datetime/widgets/simple_scroll_view.dart';


class HourScrollView  extends SimpleScrollView<int> {


  HourScrollView({
    super.selectedData,
    required super.onDataChanged,
    super.locale,
    super.options,
    super.scrollViewOptions,
  }) : super( datas: [for (int i = 0; i < 24; i++) i],keyName: "hour", );

}

