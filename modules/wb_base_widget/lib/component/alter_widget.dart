import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';


class AlterWidget {

  static alterWidget({required Widget Function(BuildContext context) builder,bool clickMaskDismiss=false}){
    SmartDialog.show(
      usePenetrate: false,
      clickMaskDismiss: clickMaskDismiss,
      builder:builder,
    );
  }

}