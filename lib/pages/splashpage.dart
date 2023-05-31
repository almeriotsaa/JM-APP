import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/pages/loginpage.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:jualmurahapp/pages/onboardingpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      SecureStorage.getToken().then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OnboardingPage()));
        }
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: HexColor('#3EB489'),
      body: Center(
        child: AnimatedSplashScreen(
          splash: Image.asset('assets/images/jmlogo.png'),
          splashIconSize: 200,
          nextScreen: LoginPage(),
          splashTransition: SplashTransition.rotationTransition,
          // duration: 1000,
          backgroundColor: HexColor('#3EB489'),
        ),
      ),
    );
  }
}
