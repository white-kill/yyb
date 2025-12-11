import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yyb/config/yyb_config/yyb_logic.dart';
import 'state.dart';
import '../../config/dio/network.dart';
import '../../config/net_config/apis.dart';
import '../../utils/sp_util.dart';
import '../../routes/app_pages.dart';

class LoginLogic extends GetxController {
  var navActionColor = Colors.white.obs;
  var agreeValue1 = true.obs;
  var agreeValue2 = true.obs;
  
  final LoginState state = LoginState();

  void onLogin() {

    final String phone = state.phoneTextController.text.trim();
    final String password = state.psdTextController.text;

    if (!agreeValue1.value) {
      _toast('请先勾选并同意相关协议');
      return;
    }
    if (!agreeValue2.value) {



      
      _toast('请先勾选并同意相关协议');
      return;
    }
    if (phone.length != 11) {
      _toast('请输入11位手机号');
      return;
    }
    if (password.isEmpty) {
      _toast('请输入登录密码');
      return;
    }


  }

  void _toast(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar('提示', message, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
  }
}
