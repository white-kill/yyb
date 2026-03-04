import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

/// 银行详情页 —— 纯图片展示
/// 通过 Get.arguments 传入图片名（不含扩展名），如 'js_detail'
class BankDetailPage extends StatelessWidget {
  const BankDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageName = Get.arguments as String? ?? '';
    return Scaffold(
      body: ListView(
        children: [
          Image(image: imageName.png, fit: BoxFit.fitWidth).withOnTap(onTap: () {
            Get.back();
          }),
        ],
      ),
    );
  }
}
