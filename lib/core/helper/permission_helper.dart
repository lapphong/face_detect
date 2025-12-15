import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<void> openSetting() async {
    await openAppSettings();
  }

  static Future<bool> checkPermission(Permission ps) async {
    final status = await ps.request();
    if (kDebugMode) {
      print('[app_core] $ps  status $status');
    }

    return status.isGranted;
  }

  static Future<List<bool>> requestPermissions(List<Permission> pss) async {
    final result = <bool>[];
    for (final ps in pss) {
      result.add(await checkPermission(ps));
    }
    return result;
  }

  static Future<bool> checkCamera() async => checkPermission(Permission.camera);
}
