import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:jualmurahapp/services/auth_service.dart';
import 'package:jualmurahapp/services/user_service.dart';

import 'mainpage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.user.name!;
    emailController.text = widget.user.email!;
    phoneController.text = widget.user.numberPhone!;
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Color(0xffF5F5F5),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Your Profile',
            style: TextStyle(
                color: Colors.grey[600],
                fontFamily: GoogleFonts.rubik().fontFamily,
                fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () {
            //  naviagtor from detail profile to main page with index 2
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MainPage(
                      )));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                // Container(
                //   width: 130,
                //   height: 130,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(100),
                //     image: const DecorationImage(
                //       image: NetworkImage(
                //           'https://www.halojabar.com/wp-content/uploads/2023/01/Basmalah-Gralind.jpg'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // enable tooltip feature with role and image
                  // same as example 7
                  // but you can add parameter img = 'your_img'
                  // background color and initial name will be replaced with the image
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: ProfilePicture(
                      name: widget.user.name.toString(),
                      radius: 31,
                      fontsize: 30,
                      tooltip: true,
                      count: 2,
                      // random: true,
                      // img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Username',
                    hintStyle:
                        TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Email',
                    hintStyle:
                        TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    labelText: 'Phone Number',
                    hintStyle:
                        TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('Inputan belum benar'),
                          ),
                        );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    final mapData = <String, dynamic>{
                      'name': nameController.text,
                      'email': emailController.text,
                      'number_phone': phoneController.text,
                    };
                    final formData = FormData.fromMap(mapData);
                    final result = await UserService.updateUser(
                        user: widget.user, form: formData);
                    if(!mounted) return;
                    Navigator.pop(context);
                    setState(() {
                      isLoading = false;
                    });
                    if (result) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainPage(
                          )));
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text('Gagal'),
                          ));
                    }
                  },
                  child:  Text('Save Profile', style: TextStyle(fontSize: 16, fontFamily: GoogleFonts.rubik().fontFamily, fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('#3EB489'),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: const Size(400, 50),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
