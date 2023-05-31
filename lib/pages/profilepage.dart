import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/pages/listproductpage.dart';
import 'package:jualmurahapp/pages/loginpage.dart';
import 'package:jualmurahapp/pages/onboardingpage.dart';
import 'package:jualmurahapp/services/auth_service.dart';

import '../local/secure_storage.dart';
import '../model/user.dart';
import '../services/product_service.dart';
import '../widget/product_widget.dart';
import 'editprofilepage.dart';

enum SampleItem { edit_profile, logout }

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  User? user;
  bool light = true;

  @override
  void initState() {
    SecureStorage.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    ProductService.getProductUser().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detail Account',
          style: TextStyle(
              fontFamily: GoogleFonts.rubik().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600]),
        ),
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Color(0xffF5F5F5),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  Stack(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            top: BorderSide(width: 2, color: Colors.grey),
                            left: BorderSide(width: 2, color: Colors.grey),
                            right: BorderSide(width: 2, color: Colors.grey),
                            bottom: BorderSide(width: 2, color: Colors.grey),
                          )),
                      width: 100,
                      height: 100,
                      child: ProfilePicture(
                        name: user?.name ?? '',
                        radius: 31,
                        fontsize: 24,
                        tooltip: true,
                        count: 2,
                        // random: true,
                        // img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
                      ),
                    ),
                  ]),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: GoogleFonts.rubik().fontFamily,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: GoogleFonts.rubik().fontFamily),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => EditProfilePage(user: user!)));
                      },
                      icon: Icon(
                        Icons.mode_edit_outline_outlined,
                        size: 20,
                        color: Colors.grey[600],
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard and Information',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.rubik().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      // backgroundColor: HexColor('#3EB489'),
                      backgroundColor: HexColor('#38beeb'),
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      user?.numberPhone ?? '',
                      style: TextStyle(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // backgroundColor: HexColor('#3EB489'),
                          backgroundColor: HexColor('#3EB489'),
                          child: Icon(
                            Icons.list_alt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'My List Item',
                          style: TextStyle(
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    CircleAvatar(
                        radius: 20,
                        // backgroundColor: HexColor('#3EB489'),
                        backgroundColor: HexColor('#cffaeb'),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const ListPage()));
                          },
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: HexColor('#3EB489'),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // backgroundColor: HexColor('#3EB489'),
                          backgroundColor: Colors.grey[600],
                          child: Icon(
                            Icons.dark_mode_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Switch(
                        value: light,
                        activeColor: Colors.grey[600],
                        onChanged: (bool value) {
                          setState(() {
                            light = value;
                          });
                        })
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.rubik().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Text(
                        'Switch to Another Account',
                        style: TextStyle(
                            fontFamily: GoogleFonts.rubik().fontFamily,
                            fontSize: 18,
                            color: HexColor('#38beeb'),
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                    'Switch to Another Account',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily),
                                  ),
                                  content: Text(
                                    'Do you want to switch account?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: HexColor('#3EB489'),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: GoogleFonts.rubik()
                                                  .fontFamily),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const OnboardingPage()));
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                              color: HexColor('#3EB489'),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: GoogleFonts.rubik()
                                                  .fontFamily),
                                        ))
                                  ],
                                ));
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              fontSize: 18,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Logout', style: TextStyle(fontFamily: GoogleFonts.rubik().fontFamily, fontWeight: FontWeight.normal, fontSize: 18),),
                              content: Text('Are you sure want to logout?', style: TextStyle(fontFamily: GoogleFonts.rubik().fontFamily, fontWeight: FontWeight.normal, fontSize: 14),),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: HexColor('#3EB489'),fontFamily: GoogleFonts.rubik().fontFamily, fontWeight: FontWeight.normal, fontSize: 14)),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final result = await AuthService.logout();
                                    Navigator.pop(context);
                                    if (result) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    }

                                    // showDialog(context: context, builder: (_) {return AlertDialog(content: Center(child: CircularProgressIndicator()));});
                                    // await ProductService.deleteProduct(product: product);
                                    // Navigator.pop(context);
                                  },
                                  child: Text('Logout',
                                      style: TextStyle(
                                          color: HexColor('#3EB489'), fontFamily: GoogleFonts.rubik().fontFamily, fontWeight: FontWeight.normal, fontSize: 14)),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       elevation: 0,
    //       // centerTitle: true,
    //       automaticallyImplyLeading: false,
    //       title: Align(
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           'Profile',
    //           style: TextStyle(
    //             color: Colors.black,
    //             fontFamily: GoogleFonts.rubik().fontFamily,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ),
    //       //  add button logout
    //       actions: [
    //         PopupMenuButton<SampleItem>(
    //           icon: Icon(
    //             Icons.more_vert_outlined,
    //             color: Colors.black,
    //             // size: 20,
    //           ),
    //           onSelected: (value) {
    //             if (value == SampleItem.edit_profile) {
    //               Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (context) => EditProfilePage(
    //                         user: user!,
    //                       )));
    //             }
    //             if (value == SampleItem.logout) {
    //               showDialog(
    //                 context: context,
    //                 builder: (context) => AlertDialog(
    //                   title: Text('Logout'),
    //                   content: Text('Are you sure want to logout?'),
    //                   actions: [
    //                     TextButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Text('Cancel',
    //                           style: TextStyle(color: HexColor('#3EB489'))),
    //                     ),
    //                     TextButton(
    //                       onPressed: () async {
    //                         final result = await AuthService.logout();
    //                         Navigator.pop(context);
    //                         if (result) {
    //                           Navigator.of(context).pushReplacement(
    //                               MaterialPageRoute(
    //                                   builder: (context) => LoginPage()));
    //                         }
    //
    //                         // showDialog(context: context, builder: (_) {return AlertDialog(content: Center(child: CircularProgressIndicator()));});
    //                         // await ProductService.deleteProduct(product: product);
    //                         // Navigator.pop(context);
    //                       },
    //                       child: Text('Logout',
    //                           style: TextStyle(color: HexColor('#3EB489'))),
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             }
    //           },
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           itemBuilder: (BuildContext context) =>
    //               <PopupMenuEntry<SampleItem>>[
    //             const PopupMenuItem<SampleItem>(
    //               value: SampleItem.edit_profile,
    //               child: Text('Edit Profile'),
    //             ),
    //             PopupMenuItem<SampleItem>(
    //               value: SampleItem.logout,
    //               child: Text('Logout'),
    //             ),
    //           ],
    //         ),
    //         // IconButton(
    //         //   onPressed: () {},
    //         //   icon: const Icon(Icons.more_vert_outlined, color: Colors.black, size: 20,),
    //         // )
    //       ],
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(children: [
    //         Row(
    //           children: [
    //             Container(
    //               // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //               // enable tooltip feature with role and image
    //               // same as example 7
    //               // but you can add parameter img = 'your_img'
    //               // background color and initial name will be replaced with the image
    //               child: SizedBox(
    //                 width: 100,
    //                 height: 100,
    //                 child: ProfilePicture(
    //                   name: user?.name ?? '',
    //                   radius: 31,
    //                   fontsize: 24,
    //                   tooltip: true,
    //                   count: 2,
    //                   // random: true,
    //                   // img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
    //                 ),
    //               ),
    //             ),
    //             // Container(
    //             //   width: 130,
    //             //   height: 130,
    //             //   decoration: BoxDecoration(
    //             //     borderRadius: BorderRadius.circular(100),
    //             //     image:  DecorationImage(
    //             //       image: NetworkImage(
    //             //           'https://www.halojabar.com/wp-content/uploads/2023/01/Basmalah-Gralind.jpg'),
    //             //       fit: BoxFit.cover,
    //             //     ),
    //             //   ),
    //             // ),
    //             const SizedBox(width: 20),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     SizedBox(width: 10),
    //                     Icon(Icons.person,
    //                         color: HexColor('#3EB489'), size: 20),
    //                     const SizedBox(width: 10),
    //                     Text(
    //                       user?.name ?? '',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w500,
    //                         fontFamily: GoogleFonts.rubik().fontFamily,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 10),
    //                 Row(
    //                   children: [
    //                     SizedBox(width: 10),
    //                     Icon(Icons.email, color: HexColor('#3EB489'), size: 20),
    //                     const SizedBox(width: 10),
    //                     Text(
    //                       user?.email ?? '',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w500,
    //                         fontFamily: GoogleFonts.rubik().fontFamily,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 const SizedBox(height: 10),
    //                 Row(
    //                   children: [
    //                     SizedBox(width: 10),
    //                     Icon(
    //                       Icons.phone,
    //                       color: HexColor('#3EB489'),
    //                       size: 20,
    //                     ),
    //                     const SizedBox(width: 10),
    //                     Text(
    //                       user?.numberPhone ?? '',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w500,
    //                         fontFamily: GoogleFonts.rubik().fontFamily,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //         const SizedBox(height: 20),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'My Item',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.w600,
    //                 fontFamily: GoogleFonts.rubik().fontFamily,
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 20),
    //         FutureBuilder(
    //             future: ProductService.getProductUser(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 return Center(
    //                   child: CircularProgressIndicator(),
    //                 );
    //               }
    //               if (snapshot.hasError) {
    //                 return Center(
    //                   child: Text(snapshot.error.toString()),
    //                 );
    //               }
    //               if (snapshot.connectionState == ConnectionState.done) {
    //                 if (snapshot.hasData) {
    //                   final products = snapshot.data!;
    //                   final users = snapshot.data!;
    //                   return Expanded(
    //                     child: RefreshIndicator(
    //                       onRefresh: _onRefresh,
    //                       child: ListView.separated(
    //                           shrinkWrap: true,
    //                           physics: BouncingScrollPhysics(),
    //                           itemBuilder: (context, index) {
    //                             return ProductWidget(
    //                               onSelected: (value) {},
    //                               product: products[index],
    //                               isInProfile: true,
    //                             );
    //                           },
    //                           separatorBuilder: (context, index) {
    //                             return SizedBox(height: 10);
    //                           },
    //                           itemCount: products.length),
    //                     ),
    //                   );
    //                 }
    //               }
    //               return SizedBox();
    //             })
    //       ]),
    //     ));
  }
}
