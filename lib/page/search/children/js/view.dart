import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class JsPage extends StatelessWidget {
  JsPage({Key? key}) : super(key: key);

  final JsLogic logic = Get.put(JsLogic());
  final JsState state = Get.find<JsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: "js_search".png),
    );
  }
}

