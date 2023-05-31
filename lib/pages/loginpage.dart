import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:jualmurahapp/pages/onboardingpage.dart';
import 'package:jualmurahapp/pages/registerpage.dart';
import 'package:jualmurahapp/services/product_service.dart';
import 'package:validators/validators.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Color(0xffF5F5F5),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => OnboardingPage()));
              },
              icon: Icon(
                Icons.arrow_back,
              ),
              color: Colors.grey[600]),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isEmail(value)) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      // labelText: 'Email',
                      hintText: 'Enter your email',
                      hintStyle:
                          TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      // labelText: 'Password',
                      hintText: 'Enter your password',
                      hintStyle:
                          TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
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
                        primary: HexColor('#3EB489'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool loginValid = false;

                          //create await with auth service

                          final res = await AuthService.login(
                              email: _emailController.text,
                              password: _passwordController.text);
                          log(res.toString());
                          setState(() {
                            loginValid = res;
                          });

                          if (loginValid) {
                            ProductService.getProduct();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainPage(),
                              ),
                              (route) => false,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Login Failed'),
                                content: Text(
                                    'Please check your email and password'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text.rich(TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontFamily: GoogleFonts.rubik().fontFamily,
                            color: HexColor('#3EB489'),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
