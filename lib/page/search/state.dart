import 'package:get/get.dart';
import '../../models/app_model.dart';
import 'package:flutter/cupertino.dart';

class SearchState {
  /// 应用列表
  RxList<AppModel> appList = <AppModel>[].obs;

  TextEditingController searchController = TextEditingController();
  
  SearchState() {
    ///Initialize variables
  }
}
