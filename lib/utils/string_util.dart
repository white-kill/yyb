import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'date_time_extension.dart';

abstract class StringUtil {

  /// 手机号中间显示星号
  /// [phone] 手机号字符串
  /// [start] 开始隐藏的位置（从0开始计数）
  /// [length] 隐藏的位数
  /// 返回格式化后的手机号，例如：138****8888
  static String maskPhoneNumber(String phone, {int start = 3, int length = 4}) {
    if (phone.isEmpty || phone.length < start + length) {
      return phone;
    }
    
    String prefix = phone.substring(0, start);
    String suffix = phone.substring(start + length);
    String stars = '*' * length;
    
    return '$prefix$stars$suffix';
  }

  /// 手机号中间4位显示星号（默认方法）
  /// [phone] 手机号字符串
  /// 返回格式化后的手机号，例如：138****8888
  static String maskPhone(String phone) {
    return maskPhoneNumber(phone, start: 3, length: 4);
  }


  /// 姓名脱敏：第一个字替换为*，保留后面的字
  /// [name] 姓名字符串
  /// 返回脱敏后的姓名，例如：'张三' 返回 '*三'，'李小明' 返回 '*小明'
  static String maskName(String? name) {
    if (name == null || name.isEmpty) {
      return '';
    }

    if (name.length == 1) {
      return name;
    }

    String suffix = name.substring(1, name.length);

    return '*$suffix';
  }

  /// 姓名脱敏：只显示最后一个字，前面的字都替换为*
  /// [name] 姓名字符串
  /// 返回脱敏后的姓名，例如：'张三' 返回 '*三'，'李小明' 返回 '**明'
  static String maskNameKeepLast(String? name) {
    if (name == null || name.isEmpty) {
      return '';
    }

    if (name.length == 1) {
      return name;
    }

    // 前面的字都替换为*，保留最后一个字
    String lastChar = name.substring(name.length - 1);
    String masked = '*' * (name.length - 1);

    return '$masked$lastChar';
  }


  static String numberFormat(String number) {
    if (number.isNum) {
      var formatter = NumberFormat("#,##0.00");
      var formattedNumber = formatter.format(double.tryParse(number));
      return formattedNumber;
    }
    return "0.00";
  }

  /// 获取字符串的后N位
  /// [str] 字符串
  /// [length] 要获取的位数，默认为4位
  /// 返回后N位字符串，如果字符串为空或长度不足，返回原字符串
  /// 例如：getLastChars('6230580000138849000', 4) 返回 '9000'
  static String getLastChars(String? str, {int length = 4}) {
    if (str == null || str.isEmpty) {
      return '';
    }
    if (str.length <= length) {
      return str;
    }
    return str.substring(str.length - length);
  }

  /// 获取字符串的后4位（快捷方法）
  /// [str] 字符串
  /// 返回后4位字符串
  /// 例如：getLast4Chars('6230580000138849000') 返回 '9000'
  static String getLast4Chars(String? str) {
    return getLastChars(str, length: 4);
  }

  /// 格式化银行卡号为 "前4位 **** **** 后4位" 格式
  /// [cardNumber] 银行卡号字符串
  /// 返回格式化后的卡号，例如：'6230580000138849000' 返回 '6230 **** **** 9000'
  /// 如果卡号为空或长度不足8位，返回原字符串
  static String maskCardNumber(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) {
      return '';
    }
    
    // 如果卡号长度不足8位，返回原字符串
    if (cardNumber.length < 8) {
      return cardNumber;
    }
    
    // 获取前4位和后4位
    String first4 = cardNumber.substring(0, 4);
    String last4 = cardNumber.substring(cardNumber.length - 4);
    
    // 返回格式化后的卡号
    return '$first4 **** ****$last4';
  }

  /// 格式化日期时间字符串为 MM-dd HH:mm 格式
  /// [dateTimeStr] 日期时间字符串，格式如 "2025-07-29 23:49:55"
  /// 返回格式化后的字符串，例如 "07-29 23:49"
  /// 如果字符串为空或格式不正确，返回原字符串
  static String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return '';
    }
    
    try {
      // 使用 DateTime.parse 解析日期时间字符串
      DateTime dateTime = DateTime.parse(dateTimeStr);
      
      // 使用 DateTimeExtension 格式化为 MM-dd HH:mm
      // 使用自定义分隔符：月日之间用 '-'，时分之间用 ':'
      return dateTime.formatString(
        type: DateTimeFormatType.MDHM,
        split: const DateSplitString(
          month: '-',
          day: '',
          hour: ':',
          minute: '',
        ),
      );
    } catch (e) {
      // 如果解析失败，返回原字符串
      return dateTimeStr;
    }
  }

}