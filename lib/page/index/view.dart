import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../tabs/dk/view.dart';
import '../tabs/wealth/view.dart';
import '../tabs/xyk/view.dart';
import 'logic.dart';
import 'state.dart';
import '../tabs/home/view.dart';
import '../tabs/mine/view.dart';

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
          children: [
            HomePage(),
            WealthPage(),
            XykPage(),
            DkPage(),
            MinePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: current,
          type: BottomNavigationBarType.fixed,
          onTap: logic.onTabChanged,
          selectedItemColor: const Color(0xFFFF6B35), // 选中状态为橙色
          unselectedItemColor: Colors.black, // 未选中状态为黑色
          selectedLabelStyle: TextStyle(fontSize: 12.sp, height: 1.5, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp, height: 1.5),
          items: [
            BottomNavigationBarItem(
              icon:
              Container(),
              activeIcon: Container(),
              label: '首页'
            ),
            BottomNavigationBarItem(
                icon:
                Container(),
                activeIcon: Container(),
              label: '财富'
            ),
            BottomNavigationBarItem(
                icon:
                Container(),
                activeIcon: Container(),
              label: '信用卡'
            ),
            BottomNavigationBarItem(
                icon:
                Container(),
                activeIcon: Container(),
              label: '贷款'
            ),
            BottomNavigationBarItem(
                icon:
                Container(),
                activeIcon: Container(),
              label: '我的'
            ),
          ],
        ),
      );
    });
  }
}

const List<String> _titles = ['首页', '财富', '信用卡', '贷款', '我的'];

class _TabBody extends StatelessWidget {
  final String label;
  const _TabBody({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}
