import 'package:device_info_plus/device_info_plus.dart';

import '../domain/entities/device_details.dart';

/// Reads the phone model and Android version with device_info_plus.
class DeviceInfoService {
  DeviceInfoService(this._deviceInfo);

  final DeviceInfoPlugin _deviceInfo;

  static const DeviceDetails _unknownDevice = DeviceDetails(
    model: 'Unknown device',
    osVersion: 'Unknown',
  );

  Future<DeviceDetails> getDeviceDetails() async {
    try {
      final info = await _deviceInfo.androidInfo;
      return DeviceDetails(
        model: '${info.manufacturer} ${info.model}',
        osVersion:
            'Android ${info.version.release} (SDK ${info.version.sdkInt})',
      );
    } catch (_) {
      // Device info is "nice to have": never break the profile screen for it.
      return _unknownDevice;
    }
  }
}
