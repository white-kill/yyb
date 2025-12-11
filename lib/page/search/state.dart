import 'package:get/get.dart';
import '../../models/app_model.dart';

class SearchState {
  /// 应用列表
  RxList<AppModel> appList = <AppModel>[].obs;
  
  SearchState() {
    ///Initialize variables
  }
}
