
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:jualmurahapp/model/product.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  UserOwner user;

  DetailPage({Key? key, required this.product, required this.user}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: HexColor('#3EB489'),
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                centerTitle: true,
                title: Text(
                  widget.product.name,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'imageHero' ' + product!.id.toString()',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: Image.network(
                              widget.product.image)
                              .image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        NumberFormat.currency(
                          locale: 'id-ID',
                          name: 'Rp ',
                          decimalDigits: 2,
                        ).format(widget.product.price).toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Description :',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: GoogleFonts.rubik().fontFamily,
                          )),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.product.description}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: HexColor('#3EB489'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                openwhatsapp();
              },
              child: Text(
                'Chat Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.rubik().fontFamily,
                ),
              ),
            ),
          ),
        )
    );
  }

  void openwhatsapp() async {
    var whatsapp = widget.user.numberPhone;
    final list = whatsapp.split('');
    if (list[0] == '0') {
      list[0] = '62';
    }
    whatsapp = list.join();

    var whatsappURl_android = "whatsapp://send?phone=${whatsapp!}&text=hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isAndroid){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatsappURl_android, forceSafariVC: false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));

      }

    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));

      }


    }
  }
}
