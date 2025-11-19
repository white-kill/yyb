import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sticky_widget.dart';

/// StickyWidget 使用示例
class StickyWidgetExample extends StatefulWidget {
  @override
  State<StickyWidgetExample> createState() => _StickyWidgetExampleState();
}

class _StickyWidgetExampleState extends State<StickyWidgetExample> {
  final ScrollController _scrollController = ScrollController();
  final StickyController _stickyController = StickyController();
  
  // 用于方式二的滚动偏移量
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    
    // 方式一：使用 StickyController
    _scrollController.addListener(() {
      _stickyController.updateScrollOffset(_scrollController.offset);
    });
    
    // 方式二：直接更新 scrollOffset（如果需要的话）
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stickyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StickyWidget Example')),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 创建足够的内容来测试滚动
                Container(height: 300.w, color: Colors.red.withOpacity(0.3)),
                Container(height: 300.w, color: Colors.green.withOpacity(0.3)),
                Container(height: 300.w, color: Colors.blue.withOpacity(0.3)),
                Container(height: 300.w, color: Colors.yellow.withOpacity(0.3)),
                Container(height: 300.w, color: Colors.purple.withOpacity(0.3)),
              ],
            ),
          ),
          
          // 方式一：使用 StickyController
          StickyWidget.withController(
            child: Container(
              height: 50.w,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Sticky Header (方式一)',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            initialOffset: 200.0,
            stickyOffset: 0.0,
            controller: _stickyController,
          ),
          
          // 方式二：直接传入 scrollOffset
          StickyWidget.withOffset(
            child: Container(
              height: 50.w,
              color: Colors.orange,
              child: Center(
                child: Text(
                  'Sticky Header (方式二)',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            initialOffset: 400.0,
            stickyOffset: 60.0, // 在第一个悬停组件下方
            scrollOffset: _scrollOffset,
          ),
        ],
      ),
    );
  }
}

/// 在现有页面中使用的示例
class ExistingPageExample {
  
  /// 方式一：使用 StickyController（推荐）
  /// 适合在 Logic 中统一管理的场景
  static Widget buildWithController(
    Widget child,
    StickyController controller,
  ) {
    return StickyWidget.withController(
      child: child,
      initialOffset: 200.0,
      stickyOffset: 0.0,
      controller: controller,
    );
  }
  
  /// 方式二：直接传入 scrollOffset
  /// 适合简单场景或需要更细粒度控制的情况
  static Widget buildWithOffset(
    Widget child,
    double scrollOffset,
  ) {
    return StickyWidget.withOffset(
      child: child,
      initialOffset: 200.0,
      stickyOffset: 0.0,
      scrollOffset: scrollOffset,
    );
  }
} 