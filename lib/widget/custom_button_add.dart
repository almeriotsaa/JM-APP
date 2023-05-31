import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/pages/addpage.dart';

import '../model/user.dart';

class CustomButton extends StatelessWidget {
  final User? user;
  final void Function()? onPressed;
  final String title;
  final double height;
  final double width;
  final Color backgroundColor;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.height,
      required this.width,
      required this.backgroundColor,
       this.user
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#3EB489'),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Center(
            child: Icon(
          Icons.add,
          size: 20,
        )),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPage(user: user,)));
        },
      ),
    );
  }
}
