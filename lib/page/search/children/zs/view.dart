import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class ZsPage extends StatelessWidget {
  ZsPage({Key? key}) : super(key: key);

  final ZsLogic logic = Get.put(ZsLogic());
  final ZsState state = Get.find<ZsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: "zs_search".png),
    );
  }
}

