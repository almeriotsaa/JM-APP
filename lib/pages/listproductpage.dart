import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:shimmer/shimmer.dart';

import '../local/secure_storage.dart';
import '../model/product.dart';
import '../model/user.dart';
import '../services/product_service.dart';
import '../widget/product_widget.dart';
import 'homepage.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isLoading = true;
  User? user;

  List<Product> productsLocal = [];
  List<Product> productsServer = [];

  Future _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    SecureStorage.getUser().then((value) {
      setState(() {
        user = value!;
      });
    });
    ProductService.getProductUser().then((listProductServer) {
      setState(() {
        productsServer = listProductServer ?? [];
        productsLocal = productsServer;
        isLoading = false;
      });
    });

  }

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My List Item',
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.rubik().fontFamily),
        ),
        elevation: 0,
        backgroundColor: Color(0xffF5F5F5),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage(index: 2,)));
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.grey[600],
            )),
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
          :Padding(
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
                            final product = productsLocal[index];
                            final isMyItem = product.user.id == user?.id;
                            return ProductWidget(
                              onSelected: (value) {},
                              product: product,
                              isMyListItem: true,
                              isMyProduct: isMyItem,
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
