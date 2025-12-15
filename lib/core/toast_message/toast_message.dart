import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'widgets/in_app_notification.dart';

enum ToastMessageType {
  success,
  warning,
  error,
}

extension ShowToastExt on State<StatefulWidget> {
  void showToastMessage(String message, [ToastMessageType type = ToastMessageType.success]) {
    _showToastMessage(context, message, type);
  }

  void showLoading() {
    BotToast.showLoading();
  }

  void hideLoading() {
    BotToast.closeAllLoading();
  }

  void showToastText(String text) {
    BotToast.showText(text: text);
  }
}

// final animationBuilder = (context, animation, child) {
//   final tween = Tween(
//     begin: const Offset(0, -1),
//     end: const Offset(0, 0),
//   ).chain(
//     CurveTween(curve: Curves.fastOutSlowIn),
//   );
//   return SlideTransition(
//     position: animation.drive(tween),
//     child: child,
//   );
// };

typedef ToastBuilder = Widget Function(BuildContext, Widget?);
final ToastBuilder toastBuilder = BotToastInit();

extension BuctxLoading on BuildContext {
  void showToastText(String text) {
    BotToast.showText(text: text);
  }

  void showLoading() {
    BotToast.showLoading();
  }

  void hideLoading() {
    BotToast.closeAllLoading();
  }

  void showToastMessage(String message, [ToastMessageType type = ToastMessageType.success]) {
    _showToastMessage(this, message, type);
  }
}

void _showToastMessage(BuildContext context, String message, [ToastMessageType type = ToastMessageType.success]) {
  var colorBg = Theme.of(context).scaffoldBackgroundColor;
  var icon = const Icon(CupertinoIcons.checkmark_circle, color: Colors.black);

  switch (type) {
    case ToastMessageType.success:
      colorBg = Colors.white;
      icon = const Icon(
        CupertinoIcons.checkmark_circle_fill,
        color: Color(0xff209653),
      );
      break;
    case ToastMessageType.warning:
      colorBg = Colors.amber[400]!;
      icon = const Icon(CupertinoIcons.info, color: Colors.white);
      break;
    case ToastMessageType.error:
      colorBg = const Color(0xffff5252);
      icon = const Icon(Icons.error, color: Colors.white);
      break;
  }

  final overlayState = Overlay.of(context);
  showTopSnackBar(
    overlayState,
    InAppNotificationWidget(
      text: message,
      colorBackground: colorBg,
      icon: icon,
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 15,
        color: ToastMessageType.success == type ? Colors.black : Colors.white,
      ),
    ),
    displayDuration: const Duration(milliseconds: 2000),
  );
}
