import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sms_simulator_plugin_method_channel.dart';

abstract class SmsSimulatorPluginPlatform extends PlatformInterface {
  /// Constructs a SmsSimulatorPluginPlatform.
  SmsSimulatorPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsSimulatorPluginPlatform _instance = MethodChannelSmsSimulatorPlugin();

  /// The default instance of [SmsSimulatorPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmsSimulatorPlugin].
  static SmsSimulatorPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmsSimulatorPluginPlatform] when
  /// they register themselves.
  static set instance(SmsSimulatorPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
