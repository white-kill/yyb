import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class PaPage extends StatelessWidget {
  PaPage({Key? key}) : super(key: key);

  final PaLogic logic = Get.put(PaLogic());
  final PaState state = Get.find<PaLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: "pa_search".png),
    );
  }
}

