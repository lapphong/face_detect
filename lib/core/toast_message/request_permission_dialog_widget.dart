import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestPermissionDialogWidget extends StatelessWidget {
  final String title;
  final String content;

  const RequestPermissionDialogWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: _buildTitle(context),
        content: _buildContent(context),
        actions: _buildActions(context),
      );
    }
    return AlertDialog(
      title: _buildTitle(context),
      content: _buildContent(context),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
    _buildAction(context, 'Lúc khác'),
    _buildAction(context, 'Mở cài đặt', value: true),
  ];

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildAction(BuildContext context, String text, {bool? value}) {
    if (Platform.isIOS) {
      return CupertinoDialogAction(
        onPressed: () => Navigator.pop(context, value),
        child: Text(text),
      );
    }
    return TextButton(
      onPressed: () => Navigator.pop(context, value),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
