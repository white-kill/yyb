class Apis {

  static const login = '/login';

  /// 账户纵览查询
  static const accountInfo = '/PABankUserInfo/getAccountInfo';

  /// 收支明细
  static const billList = '/PABankUserInfo/getBillDetailInfo';

  /// 最近几个月的收支
  static const monthBill = '/PABankUserInfo/getSixMonthDetail';

  ///用户信息
  static const memberInfo = '/PABankUserInfo/getUserInfo';

  ///最近转账伙伴列表
  static const companionList = '/PABankUserInfo/getCompanionList';

  ///转账信息
  static const transferInfo = '/PABankUserInfo/getTransferInfo';

  ///提交转账
  static const handleTransfer = '/PABankUserInfo/handleTransfer';

  ///进去个人账户交易明细页面
  static const getEmailInfo = '/PABankUserInfo/getEmailInfo';

  ///提交个人账户交易明细页面
  static const sendEmail = '/PABankUserInfo/sendEmail';

  /// 转账记录
  static const transferRecord = '/PABankUserInfo/getTransferRecord';

  /// 打印记录
  static const printRecord = '/PABankUserInfo/getEmailList';

}