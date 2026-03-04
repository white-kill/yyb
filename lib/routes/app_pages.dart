import 'package:get/get.dart';
import 'package:yyb/page/common/change_navi/change_navi_view.dart';
import 'package:yyb/page/search/view.dart';
import 'package:yyb/page/search/children/gs/view.dart';
import 'package:yyb/page/search/children/js/view.dart';
import 'package:yyb/page/search/children/ny/view.dart';
import 'package:yyb/page/search/children/pa/view.dart';
import 'package:yyb/page/search/children/detail/bank_detail_page.dart';
import 'package:yyb/page/search/children/yz/view.dart';
import 'package:yyb/page/search/children/zs/view.dart';
import '../page/index/view.dart';
import '../page/login/view.dart';
import '../page/splash/splash_view.dart';
import '../page/common/fixed_nav/fixed_nav_view.dart';
import '../page/common/common_nav/common_nav_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.tabs,
      page: () => IndexPage(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.splashPage,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.fixedNavPage,
      page: () => FixedNavPage(),
    ),
    GetPage(name: Routes.changeNavPage, page: () => ChangeNavPage()),
    GetPage(
      name: Routes.commonNavPage,
      page: () => CommonNavPage(),
    ),
    GetPage(name: Routes.searchPage, page: () => SearchPage()),
    GetPage(name: Routes.gsPage, page: () => GsPage()),
    GetPage(name: Routes.jsPage, page: () => JsPage()),
    GetPage(name: Routes.nyPage, page: () => NyPage()),
    GetPage(name: Routes.paPage, page: () => PaPage()),
    GetPage(name: Routes.zsPage, page: () => ZsPage()),
    GetPage(name: Routes.yzPage, page: () => YzPage()),
    GetPage(name: Routes.bankDetailPage, page: () => const BankDetailPage()),
  ];
}
