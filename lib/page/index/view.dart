import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'logic.dart';
import 'state.dart';
import '../tabs/home/view.dart';
import '../tabs/mine/view.dart';
import '../tabs/mw/view.dart';
import '../tabs/yxk/view.dart';
import '../tabs/fl/view.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  final IndexLogic logic = Get.put(IndexLogic());
  final IndexState state = Get.find<IndexLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int current = state.currentIndex.value;
      return Scaffold(
        body: IndexedStack(
          index: current,
          children: [HomePage(), MwPage(), YxkPage(), FlPage(), MinePage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: current,
          type: BottomNavigationBarType.fixed,
          onTap: logic.onTabChanged,
          selectedItemColor: Colors.black, // 选中状态为橙色
          unselectedItemColor: Colors.black54, // 未选中状态为黑色
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            height: 1.5,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp, height: 1.5),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_1_unselect').png3x, width: 24, height: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_1_select').png3x, width: 24, height: 24),
              ),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_2_unselect').png3x, width: 24, height: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_2_select').png3x, width: 24, height: 24),
              ),
              label: '秒玩',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_3_unselect').png3x, width: 24, height: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_3_select').png3x, width: 24, height: 24),
              ),
              label: '游戏库',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_4_unselect').png3x, width: 24, height: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_4_select').png3x, width: 24, height: 24),
              ),
              label: '福利',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_5_unselect').png3x, width: 24, height: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: Image(image: ('tabbar_5_select').png3x, width: 24, height: 24),
              ),
              label: '我的',
            ),
          ],
        ),
      );
    });
  }
}

const List<String> _titles = ['首页', '秒玩', '游戏库', '福利', '我的'];

class _TabBody extends StatelessWidget {
  final String label;
  const _TabBody({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}
