import 'package:flutter/material.dart';

import 'app_bar_widget.dart';

typedef BodyWidgetBuilder = Widget Function(BuildContext context);

mixin StateWidgetConfig {

  Function? get backCallBack => null;

  Widget? get titleWidget => null;

  Widget? get leftItem => null;

  double? get lefItemWidth => null;

  List<Widget>? get rightAction => null;

  double? get scrollDistance => 0.0;

  bool get enablePullUp => true;

  bool get enablePullDown => true;

  Color? get navColor => null;

  Color? get titleColor => null;

  bool get bottomInset => true;

  Widget? get bottomNav => null;

  Color? get background => null;

  Color? get backColor => Colors.black;

  bool get isShowAppBar => true;

  bool get isWantKeepAlive => false;

  bool get isChangeNav => false;

  bool get noBackGround1 => true;

  Function(bool change, double percentage)? get onNotificationNavChange => null;

  dynamic get refreshController => null;

  AppBarController? get appBarController => null;

  void onRefresh() {}

  void onLoading() {}

  ///界面进入
  void initDefaultState() {}

  ///界面销毁
  void initDefaultDispose() {}



}