import 'dart:developer';
import 'dart:io';

import 'package:clarigo_project/view/main_navigation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constanst/color_constanst.dart';
import '../../../constanst/constans.dart';
import '../../../services/db.dart';
import '../../../utils/widgets/elevated_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../splash/splash_Screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  int isVerified = 0;
  int pageIndex = 0;
  bool isLoading = false;
  int? resendOtp;
  bool passwordVisibility = true;

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? passwordValidator(String value) {
    if (value == "") {
      return AppConstants.passwordValidationText1;
    } else if (value.length < 6) {
      return AppConstants.passwordValidationText2;
    } else {
      return null;
    }
  }

  String? emailValidator(String val) {
    return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val)
        ? null
        : AppConstants.enterEmailText;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstants.scaffoldBackGroundThemeColor,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        children: [
          SizedBox(height: 107.h),
          Center(
            child: Text(
              AppConstants.appName,
              style: GoogleFonts.dmSans(
                  fontSize: 40.sp, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 40.h),
          loginFormAndButton(context),
        ],
      ),
    );
  }

  Form loginFormAndButton(BuildContext context) {
    return Form(
      key: loginKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: GoogleFonts.openSans(
                  fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              textInputAction: TextInputAction.next,
              validator: (value) => emailValidator(value!),
              autovalidateMode: autoValidateMode,
              decoration: textInputDecoration.copyWith(
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.mail,
                  color: ColorConstants.textFieldIconColors,
                ),
              ),
              autofocus: false,
            ),
            SizedBox(height: 16.h),
            Text(
              "Password",
              style: GoogleFonts.openSans(
                  fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              validator: (value) => passwordValidator(value!),
              autovalidateMode: autoValidateMode,
              obscureText: passwordVisibility,
              decoration: textInputDecoration.copyWith(
                hintText: AppConstants.passwordText,
                prefixIcon: Icon(
                  Icons.lock,
                  color: ColorConstants.textFieldIconColors,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    passwordVisibility = !passwordVisibility;
                    setState(() {});
                  },
                  child: Icon(
                    !passwordVisibility
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined,
                    color: ColorConstants.textFieldIconColors,
                    size: 20.sp,
                  ),
                ),
              ),
              autofocus: false,
            ),
            SizedBox(height: 8.h),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: AppConstants.weAreWorkingOnIt,backgroundColor: Colors.white,textColor: Colors.black);

                    },
                    child: Text(AppConstants.forgotPasswordText2,
                        style: GoogleFonts.dmSans(
                            fontSize: 14.sp, fontWeight: FontWeight.w400)))),
            SizedBox(height: 32.h),
            isLoading == false
                ? Center(
                    child: ReusableElevatedButton(
                      onPressed: () {
                        login();
                      },
                      width: 328,
                      height: 39,
                      child: Text(
                        AppConstants.signInText2,
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.primaryThemeColor,
                            fontSize: 16.sp),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                        color: ColorConstants.secondryThemeColor),
                  ),
            SizedBox(height: 40.h),
            Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppConstants.newUserText,
                    style: GoogleFonts.openSans(
                        fontSize: 14.sp, fontWeight: FontWeight.w400)),
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: AppConstants.weAreWorkingOnIt,backgroundColor: Colors.white,textColor: Colors.black);
                  },
                  child: Text(AppConstants.signupText,
                      style: GoogleFonts.openSans(
                          fontSize: 14.sp, fontWeight: FontWeight.w600)),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    if (loginKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      autoValidateMode = AutovalidateMode.disabled;
Db.setAuthToken(emailController.text);
      final route = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
      setState(() {
        isLoading = false;
      });
    } else {
      autoValidateMode = AutovalidateMode.always;
    }
  }
}
