import 'dart:async';
import 'dart:developer';
import 'package:clarigo_project/view/main_navigation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constanst/color_constanst.dart';
import '../../constanst/constans.dart';
import '../../services/db.dart';
import '../auth/log_in_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      getUserLoggedInStatus();
    });
    super.initState();
  }

  getUserLoggedInStatus() async {
    await Db.getAuthToken().then((value) async {
      log("value : $value");
      if (value == "" || value == null) {
        final route = MaterialPageRoute(builder: (context) => LogInScreen());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
        // nextScreenReplace(context, LogInScreen());
      } else {
        final route =
            MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.scaffoldBackGroundThemeColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppConstants.appLogo,height: 200.h,width: 250.w,),
            Center(
              child: Text(
                AppConstants.appName,
                style: GoogleFonts.dmSans(
                    fontSize: 40.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ));
  }
}
