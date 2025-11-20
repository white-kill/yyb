import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

import 'logic.dart';
import 'state.dart';

class NyPage extends StatelessWidget {
  NyPage({Key? key}) : super(key: key);

  final NyLogic logic = Get.put(NyLogic());
  final NyState state = Get.find<NyLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: "ny_search".png),
    );
  }
}

