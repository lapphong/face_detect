import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/core.dart';

extension AleartDialogExt on BuildContext {
  void checkAndRequestPermissionCamera({required VoidCallback? completed}) async {
    PermissionHelper.checkCamera().then((granted) {
      if (granted != true) {
        showDialogRequestPermission(
          'Notification',
          'Please grant permission camera in settings',
        );
      } else {
        completed?.call();
      }
    });
  }

  Future<bool> showDialogRequestPermission<T>(String title, String content) {
    return showDialog(
      context: this,
      builder: (ctx) => RequestPermissionDialogWidget(content: content, title: title),
    ).then((success) {
      if (success is bool && success) {
        return openAppSettings();
      }
      return false;
    });
  }
}
