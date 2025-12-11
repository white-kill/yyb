/// 应用文件对象
class AppModel {
  /// 主键ID
  int? id;
  
  /// 上传用户ID
  int? userId;
  
  /// 文件ID(相同应用的不同版本共用)
  int? fileId;
  
  /// 应用包名
  String? bundleId;
  
  /// 文件名
  String? fileName;
  
  /// 文件大小(字节数)
  int? fileSize;
  
  /// 版本号(如"1.0","2.0")
  String? fileVersion;
  
  /// 图标URL
  String? icon;
  
  /// 下载次数
  int? downloadCount;
  
  /// 下载链接
  String? downloadUrl;
  
  /// 二维码(Base64格式)
  String? qrCode;
  
  /// 状态:0-正常,1-旧版本,2-停用
  String? status;
  
  /// 备注
  String? remark;
  
  /// 创建者
  String? createBy;
  
  /// 创建时间
  String? createTime;
  
  /// 更新者
  String? updateBy;
  
  /// 更新时间
  String? updateTime;

  AppModel({
    this.id,
    this.userId,
    this.fileId,
    this.bundleId,
    this.fileName,
    this.fileSize,
    this.fileVersion,
    this.icon,
    this.downloadCount,
    this.downloadUrl,
    this.qrCode,
    this.status,
    this.remark,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
  });

  /// 从JSON创建对象
  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      fileId: json['fileId'] as int?,
      bundleId: json['bundleId'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: json['fileSize'] as int?,
      fileVersion: json['fileVersion'] as String?,
      icon: json['icon'] as String?,
      downloadCount: json['downloadCount'] as int?,
      downloadUrl: json['downloadUrl'] as String?,
      qrCode: json['qrCode'] as String?,
      status: json['status'] as String?,
      remark: json['remark'] as String?,
      createBy: json['createBy'] as String?,
      createTime: json['createTime'] as String?,
      updateBy: json['updateBy'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileId': fileId,
      'bundleId': bundleId,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileVersion': fileVersion,
      'icon': icon,
      'downloadCount': downloadCount,
      'downloadUrl': downloadUrl,
      'qrCode': qrCode,
      'status': status,
      'remark': remark,
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
    };
  }

  /// 格式化文件大小（字节转MB/GB）
  String get formattedFileSize {
    if (fileSize == null) return '未知';
    
    final bytes = fileSize!;
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  @override
  String toString() {
    return 'AppModel(id: $id, fileName: $fileName, version: $fileVersion, bundleId: $bundleId)';
  }
}

