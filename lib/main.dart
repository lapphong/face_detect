import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/toast_message/toast_message.dart';
import 'data/alias_hive.dart';
import 'ui/bloc/face_detection_bloc.dart';
import 'ui/face_detection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final aliasHive = await AliasHive.factory();
  runApp(Application(aliasHive: aliasHive));
}

class Application extends StatelessWidget {
  final AliasHive aliasHive;

  const Application({super.key, required this.aliasHive});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1E90FF),
          primary: const Color(0xff1E90FF),
          secondary: const Color.fromARGB(255, 0, 157, 255),
          onSurface: const Color(0xff333333),
          surface: const Color(0xffF5F5F5),
          error: const Color(0xffD90000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      builder: _materialBuilder,
      home: BlocProvider<FaceDetectionBloc>(
        create: (context) => FaceDetectionBloc(aliasHive),
        child: const FaceDetectionScreen(),
      ),
    );
  }

  Overlay _materialBuilder(BuildContext context, Widget? child) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return Material(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: toastBuilder(context, child!),
              ),
            );
          },
        ),
      ],
    );
  }
}
