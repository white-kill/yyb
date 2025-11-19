import 'package:get/get.dart';
import '../index/view.dart';
import 'splash_state.dart';

class SplashLogic extends GetxController {
  final SplashState state = SplashState();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      Get.offAll(() => IndexPage(),transition: Transition.noTransition);

      // Get.offAll(() => token.isNullOrEmpty ? LoginPage() : IndexPage(),transition: Transition.noTransition);
    });
  }
}
