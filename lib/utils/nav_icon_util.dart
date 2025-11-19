import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/extension/widget_extension.dart';

/// 导航栏右侧图标类型枚举
enum NavIconType {
  dog,          // 小狗图标
  dog2,         // 小狗图标2
  search,       // 搜索图标
  home,         // 首页图标
  share,        // 分享图标
  guanli,       // 管理文本
  jinduchaxun,  // 进度查询文本
  houzi,
}

/// 导航栏图标工具类
class NavIconUtil {
  /// 根据枚举类型获取对应的导航栏图标Widget
  static Widget getNavIcon(NavIconType type) {
    switch (type) {
      case NavIconType.dog:
        return Image(
          image: 'home_nav_dog'.png3x,
          width: 24.w,
          height: 24.w,
        ).withPadding(right: 22.w, top: 2.w);

      case NavIconType.dog2:
        return Image(
          image: 'home_nav_dog2'.png3x,
          width: 28.w,
          height: 28.w,
        ).withPadding(right: 22.w, top: 2.w);

      case NavIconType.search:
        return Image(
          image: 'home_nav_search'.png3x,
          width: 21.w,
          height: 21.w,
        ).withPadding(right: 22.w);

      case NavIconType.home:
        return Image(
          image: 'home_nav_home'.png3x,
          width: 20.w,
          height: 20.w,
        ).withPadding(right: 22.w);

      case NavIconType.share:
        return Image(
          image: 'home_nav_share'.png3x,
          width: 24.w,
          height: 24.w,
        ).withPadding(right: 22.w);

      case NavIconType.guanli:
        return Text(
          "管理",
          style: TextStyle(
            fontSize: 13.w,
            fontFamily: "PingFang",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ).withPadding(right: 22.w, top: 20.w);

      case NavIconType.jinduchaxun:
        return Text(
          "进度查询",
          style: TextStyle(
            fontSize: 13.w,
            fontWeight: FontWeight.bold,
            fontFamily: "PingFang",
            color: Colors.black,
            height: 1.0,
          ),
        ).withPadding(right: 22.w, top: 20.w);
      case NavIconType.houzi:
        return Image(image: "mine_right_1".png, width: 20.w, color: Colors.black).withPadding(right: 22.w);
    }
  }

  /// 根据字符串获取枚举类型
  static NavIconType? getNavIconTypeFromString(String typeString) {
    switch (typeString) {
      case 'dog':
        return NavIconType.dog;
      case 'dog2':
        return NavIconType.dog2;
      case 'search':
        return NavIconType.search;
      case 'home':
        return NavIconType.home;
      case 'share':
        return NavIconType.share;
      case 'guanli':
        return NavIconType.guanli;
      case 'jinduchaxun':
        return NavIconType.jinduchaxun;
      default:
        return null;
    }
  }

  /// 根据字符串列表获取导航栏图标Widget列表
  static List<Widget> getNavIconsFromStringList(List<String> typeList) {
    List<Widget> widgets = [];
    for (String typeString in typeList) {
      NavIconType? type = getNavIconTypeFromString(typeString);
      if (type != null) {
        widgets.add(getNavIcon(type));
      }
    }
    return widgets;
  }

  /// 根据枚举列表获取导航栏图标Widget列表
  static List<Widget> getNavIconsFromEnumList(List<NavIconType> typeList) {
    return typeList.map((type) => getNavIcon(type)).toList();
  }
}

