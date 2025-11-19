import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import 'package:wb_base_widget/state_widget/state_less_widget.dart';
import 'package:yyb/utils/stack_position.dart';
import 'package:yyb/utils/clean_text_field.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends BaseStateless {
  LoginPage({Key? key}) : super(key: key);

  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get
      .find<LoginLogic>()
      .state;

  @override
  bool get isShowAppBar => false;

  @override
  Widget initBody(BuildContext context) {
    return Container();
  }
}
