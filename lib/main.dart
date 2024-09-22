import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:clarigo_project/services/providers/user_provider.dart';
import 'package:clarigo_project/view/splash/splash_Screen.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MyApp(),
    ),
  );}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360.0, 640.0),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return ConnectionNotifier(

        //  disconnectedText: "No Connection",
          child: MaterialApp(
              theme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              home: const SplashScreen()),
        );
      },
    );
  }
}
