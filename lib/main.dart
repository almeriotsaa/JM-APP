import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:jualmurahapp/pages/splashpage.dart';
import 'package:jualmurahapp/services/auth_service.dart';
import 'package:jualmurahapp/services/notification_service.dart';

import 'pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
    requestHeader: true,
    error: true,
    request: true,
    responseHeader: true,
  ));
  await NotificationService.init();
  //
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  await Future.delayed(const Duration(seconds: 1));
  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
