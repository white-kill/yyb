import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class GsPage extends StatelessWidget {
  GsPage({Key? key}) : super(key: key);

  final GsLogic logic = Get.put(GsLogic());
  final GsState state = Get.find<GsLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: "gs_search".png),
    );
  }
}
