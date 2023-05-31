import 'dart:developer';

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:jualmurahapp/pages/addpage.dart';
import 'package:jualmurahapp/pages/homepage.dart';
import 'package:jualmurahapp/pages/profilepage.dart';
import 'package:jualmurahapp/widget/custom_button_add.dart';

import 'loginpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.index}) : super(key: key);
  final int? index;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool isVisible = false;
  bool isLoading = true;
  User? user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isVisible = true;
    });
  }

  @override
  void initState() {
    SecureStorage.getUser().then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      setState(() {
        user = value;

        isLoading = false;
      });
    });
    setState(() {
      isVisible = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('MainPage.build(context: $context)');
    // if (widget.index != null) {
    //   _selectedIndex = widget.index!;
    // }
    List<Widget> pages = [
      HomePage(),
      // AddPage(user: user!=null? user: null),
      ProfilePage()
    ];

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : pages.elementAt(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: isVisible
          ? FloatingNavbar(
        borderRadius: 50,
              width: 350,
              margin: EdgeInsets.symmetric(vertical: 10),
              backgroundColor: HexColor('#cffaeb'),
              itemBorderRadius: 50,
              iconSize: 25,
              items: [
                FloatingNavbarItem(
                    icon: Icons.home_filled, title: 'Home'
                ),
                // FloatingNavbarItem(
                //     icon: Icons.add_to_photos_rounded, title: 'Add'
                // ),
                FloatingNavbarItem(
                    icon: Icons.person, title: 'Account'
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: HexColor('#3EB489'),
              unselectedItemColor: Colors.grey,
              // children: [
              //   Row(
              //     //children inside bottom appbar
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       IconButton(
              //         icon: Icon(
              //           Icons.home,
              //           color: Colors.grey,
              //           size: 30,
              //         ),
              //         onPressed: () {
              //           _onItemTapped(0);
              //           if (_selectedIndex == _selectedIndex) {
              //           //  change color icon
              //
              //           }
              //         },
              //       ),
              //       // IconButton(icon: Icon(Icons.add, color: Colors.black,), onPressed: () {
              //       //   setState(() {
              //       //     isVisible = false;
              //       //   });
              //       //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPage()));
              //       // },),
              //       CustomButton(
              //           onPressed: () {
              //             Navigator.of(context).push(
              //                 MaterialPageRoute(builder: (context) => AddPage()));
              //           },
              //           title: 'Add',
              //           height: 30,
              //           width: 50,
              //           backgroundColor: HexColor('#3EB489')),
              //       IconButton(
              //         icon: Icon(
              //           Icons.person,
              //           color: Colors.grey,
              //           size: 30,
              //         ),
              //         onPressed: () {
              //           _onItemTapped(2);
              //         },
              //       ),
              //     ],
              //   ),
              // ],
            )
          : null,
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //       backgroundColor: Colors.blue,
      //     ),
      //   ],
      // ),
    );
  }
}
