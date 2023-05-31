import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:jualmurahapp/pages/listproductpage.dart';
import 'package:jualmurahapp/widget/product_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../model/product.dart';
import '../services/product_service.dart';
import 'addpage.dart';

enum SampleItem { edit, delete }

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SampleItem? selectedMenu;
  bool isLoading = true;
  User? user;
  final _debouncer = Debouncer();

  final searchController = TextEditingController();

  Future _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    ProductService.getProduct().then((listProductServer) {
      setState(() {
        productsServer = listProductServer ?? [];
        productsLocal = productsServer;
        isLoading = false;
      });
    });
  }

  List<Product> productsLocal = [];
  List<Product> productsServer = [];

  @override
  void initState() {
    SecureStorage.getUser().then((value) {
      setState(() {
        user = value!;
      });
    });
    ProductService.getProduct().then((listProductServer) {
      setState(() {
        productsServer = listProductServer ?? [];
        productsLocal = productsServer;
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
        toolbarHeight: 170,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.add_to_photos_rounded, color: Colors.grey[600],))
        // ],
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome,',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              fontWeight: FontWeight.w500)),
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                            color: HexColor('#3EB489'),
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.rubik().fontFamily,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPage()));
                      },
                      icon: Icon(
                        Icons.add_to_photos_rounded,
                        color: Colors.grey[600],
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: searchController,
                // textAlign: TextAlign.center,
                minLines: 1,
                maxLines: 1,
                autocorrect: false,
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      boxShadow: [
                        //background color of box
                        BoxShadow(
                          color: Color(0xffe5e5e5),
                          blurRadius: 5.0, // soften the shadow
                          spreadRadius: 1.0, //extend the shadow
                          offset:
                              Offset(0.0, 0.0 // Move to bottom 10 Vertically
                                  ),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Icon(
                      Icons.travel_explore,
                      color: HexColor('#3EB489'),
                    ),
                  ),
                  hintText: 'Search product',
                  hintStyle: GoogleFonts.rubik(
                      color: Colors.grey[350],
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xffeaeaea),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Color(0xffeaeaea)),
                  ),
                ),
                onChanged: (value) {
                  _debouncer.run(() {
                    setState(() {
                      productsLocal = productsServer
                          .where((element) => element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase())
                              // element.name.contains(value)
                              )
                          .toList();
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const SizedBox(height: 500),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductWidget(
                              onSelected: (value) {},
                              product: productsLocal[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemCount: productsLocal.length),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
