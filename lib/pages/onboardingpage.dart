import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/pages/loginpage.dart';
import 'package:jualmurahapp/pages/registerpage.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset('assets/images/jmlogo.png', width: 100),
              Image.asset('assets/images/bannerjm.png'),
              SizedBox(height: 20),
              Text('Welcome to',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.rubik().fontFamily)),
              Text('Jual Murah!',
                  style: TextStyle(
                      color: HexColor('#3EB489'),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.rubik().fontFamily)),
              SizedBox(height: 30),
              Text('We have been around since 2023,',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.rubik().fontFamily)),
              Text('to sell products and around Indonesia.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.rubik().fontFamily)),
              // Text('around Indonesia.',
              //     style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.normal,
              //         fontFamily: GoogleFonts.rubik().fontFamily)),
              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: HexColor('#3EB489'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                  child: Text('Sign In',
                      style: TextStyle(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          fontSize: 16)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    side: BorderSide(
                      width: 2,
                      color: HexColor('#3EB489'),
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => RegisterPage()));
                  },
                  child: Text('Create account',
                      style: TextStyle(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          fontSize: 16,
                          color: HexColor('#3EB489'))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
