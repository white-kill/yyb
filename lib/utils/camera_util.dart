import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CameraUtil {

  /// 拍照/视频
  ///
  /// [isAllowRecording] 选择器是否可以录像
  /// [isOnlyAllowRecording] 选择器是否可以录像
  /// [enableAudio] 选择器录像时是否需要录制声音
  /// [maximumRecordingDuration] 录制视频最长时长
  /// [resolutionPreset] 相机的分辨率预设
  static Future<AssetEntity?> cameraPicker(BuildContext context, {
        ResolutionPreset resolutionPreset = ResolutionPreset.medium}) async {

    /// 拉起相机
    final AssetEntity? entity = await CameraPicker.pickFromCamera(context,

      pickerConfig: CameraPickerConfig(
          enableRecording: false,
          onlyEnableRecording: false,
          enableAudio: false,
          resolutionPreset: ResolutionPreset.medium,
      ),);
    return entity;
  }

 static Future<bool> videoRequestCameraPermission() async {
    //获取当前的权限
    var status = await Permission.camera.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}