import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InAppNotificationWidget extends StatelessWidget {
  final String text;
  final Color? colorBackground;
  final TextStyle? textStyle;
  final Widget? icon;
  final Color? colorIcon;

  const InAppNotificationWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.colorBackground,
    this.icon,
    this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color(0xffD1D3D4),
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          color: colorBackground ?? Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  icon ??
                  Icon(
                    CupertinoIcons.checkmark_circle,
                    color: colorIcon ?? Colors.black,
                  ),
            ),
            Expanded(
              child: Text(
                text,
                style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
