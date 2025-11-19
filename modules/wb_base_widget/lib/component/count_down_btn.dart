import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';


typedef BtnClick = void Function();

const int _normalTime = 60; //默认 倒计时时间
const String _normalText = '获取验证码'; //默认 按钮文字

class WzhCountDownBtn extends StatefulWidget {
  final Future<bool> Function()? getVCode;
  final Color? textColor;
  final CountDownBtnController? controller;
  final bool showBord;

  const WzhCountDownBtn({
    Key? key,
    this.getVCode,
    this.textColor,
    this.controller,
    this.showBord = true,
  }) : super(key: key);

  @override
  _CpdCountDownBtnState createState() => _CpdCountDownBtnState();
}

class _CpdCountDownBtnState extends State<WzhCountDownBtn> {
  Timer? _countDownTimer;
  String _btnStr = _normalText;
  int _countDownNum = _normalTime;
  bool _isClick = true;
  BtnClick? onTap;

  @override
  void initState() {
    super.initState();
    // _getCode();
    widget.controller?.addListener(_onController);
  }

  _onController() {
    if (mounted) {
      setState(() {
        if (widget.controller!.isClick = true) {
          if (_isClick) {
            _getCode();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.getVCode == null) {
      return Container();
    } else {
      return _countDownText();
    }
  }

  Widget _countDownText(){
    return InkWell(
      onTap: (){
        _getCode();
      },
      child: Container(
        width: 80.w,
        height: 38.w,
        decoration: widget.showBord?BoxDecoration(
          borderRadius: BorderRadius.circular(2.w),
          color: _isClick ?null : const Color(0xffC5D9F8),
          gradient: _isClick
              ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xff3768CB), Color(0xff6FACF9)], // 渐变色列表
          ): null,
        ):null,
        child: Center(
            child: BaseText(text: _btnStr,color: widget.showBord?Colors.white:Colors.orangeAccent ,fontSize: 13.sp,)
        ),
      ),
    );
  }

  Future _getCode() async {
    bool isSuccess = await widget.getVCode!();
    if (isSuccess && _isClick) {
      _isClick = false;
      startCountdown();
    }
  }

  //开始倒计时
  void startCountdown() {
    setState(() {
      if (_countDownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _btnStr = '${_countDownNum--}s后重新获取';
      _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countDownNum > 0) {
            _btnStr ='${_countDownNum--}s重新获取';
          } else {
            _isClick = true;
            _btnStr = _normalText;
            _countDownNum = _normalTime;
            _countDownTimer?.cancel();
            _countDownTimer = null;
          }
        });
      });
    });
  }

  //释放掉Timer
  @override
  void dispose() {
    _countDownTimer?.cancel();
    _countDownTimer = null;
    super.dispose();
  }
}

//统一设置按钮选择提供外部方法的
class CountDownBtnController extends ChangeNotifier {
  bool isClick = false;

  void click() {
    isClick = true;
    notifyListeners();
  }
}
