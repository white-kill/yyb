import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';
import '../../routes/app_pages.dart';
import '../../utils/sp_util.dart';
import '../dio/network.dart';
import '../net_config/apis.dart';

class YybLogic extends GetxController {
  var showValue = false.obs;

  // AccountInfoEntity accountInfoEntity = AccountInfoEntity();
  //
  // MemberInfoModel memberInfo = MemberInfoModel();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void onInit() {
    super.onInit();
    // accountInfoData();
    // memberInfoData();
  }

  updateInfo() {
    // accountInfoData();
    // memberInfoData();
  }

  logoutWithUI() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Stack(
          children: [
            Image(image: "logout_bottom".png),
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(width: 1.sw, height: 100.w).withOnTap(
                onTap: () {
                  Get.back();
                  logout();
                },
              ),
            ),
            Positioned(
              top: 100.w,
              left: 0,
              child: SizedBox(width: 1.sw, height: 50.w).withOnTap(
                onTap: () {
                  Get.back();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  logout() {
    ''.saveToken;
    Get.offAllNamed(Routes.login);
  }

  // /// 获取账户信息
  // Future accountInfoData() async {
  //   if (token == '') return;
  //   await Http.get(Apis.accountInfo).then((value) {
  //     print('accountInfoData $value');
  //     if (value is Map<String, dynamic>) {
  //       accountInfoEntity = AccountInfoEntity.fromJson(value);
  //       update(['updateBalance', 'updateUI', 'updateCard']);
  //     }
  //   });
  // }
  //
  // Future memberInfoData() async {
  //   if (token == '') return;
  //   await Http.get(Apis.memberInfo).then((value) {
  //     print('memberInfoData $value');
  //     if (value is Map<String, dynamic>) {
  //       memberInfo = MemberInfoModel.fromJson(value);
  //       update(['updateMemberInfo', 'updateUI', 'updateCard']);
  //     }
  //   });
  // }

}
