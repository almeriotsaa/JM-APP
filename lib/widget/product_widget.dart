import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/model/product.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:jualmurahapp/pages/detailpage.dart';
import 'package:jualmurahapp/pages/editpage.dart';
import 'package:jualmurahapp/pages/listproductpage.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:jualmurahapp/pages/profilepage.dart' hide SampleItem;

import '../pages/homepage.dart';
import '../services/product_service.dart';

class ProductWidget extends StatefulWidget {
  ProductWidget(
      {Key? key,
      required this.onSelected,
      required this.product,
      this.isMyListItem = false,
      this.isMyProduct = false})
      : super(key: key);

  void Function(SampleItem)? onSelected;
  final Product product;
  final bool isMyListItem;
  final bool isMyProduct;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    SecureStorage.getUser().then((value) {
      if (mounted) {
        setState(() {
          user = value;
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            width: double.infinity,
            height: 500,
            child: InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      product: widget.product,
                      user: widget.product.user,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    Stack(children: <Widget>[
                      Hero(
                        tag: widget.product.id,
                        child: Container(
                          width: double.infinity,
                          height: 430,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image:
                                    Image.network(widget.product.image).image,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 340,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Stack(children: <Widget>[
                            SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              // bottom: 50,
                              top: 15,
                              left: 30,
                              right: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      widget.product.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id-ID',
                                      name: 'Rp ',
                                      decimalDigits: 2,
                                    ).format(widget.product.price).toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily:
                                          GoogleFonts.rubik().fontFamily,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      widget.product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: ProfilePicture(
                                              name: widget.product.user.name,
                                              radius: 31,
                                              fontsize: 11,
                                              tooltip: true,
                                              count: 2,
                                              // random: true,
                                              // img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.product.user.name,
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontFamily: GoogleFonts.rubik()
                                                  .fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (widget.isMyListItem &&
                                          widget.isMyProduct)
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircleAvatar(
                                                radius: 30,
                                                // backgroundColor: HexColor('#3EB489'),
                                                backgroundColor: Colors.orange,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .mode_edit_outline_outlined,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditPage(
                                                            product:
                                                                widget.product,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircleAvatar(
                                                radius: 30,
                                                // backgroundColor: HexColor('#3EB489'),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .delete_outline_outlined,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text('Delete', style: TextStyle(fontSize: 18,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily:
                                                              GoogleFonts.rubik().fontFamily),),
                                                          content: Text(
                                                              'Are you sure want to delete this item?', style: TextStyle(fontSize: 14,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily:
                                                              GoogleFonts.rubik().fontFamily),),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontFamily:
                                                                          GoogleFonts.rubik()
                                                                              .fontFamily,
                                                                      color: HexColor(
                                                                          '#3EB489'))),
                                                            ),
                                                            isLoading
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      FocusManager
                                                                          .instance
                                                                          ?.primaryFocus
                                                                          ?.unfocus();
                                                                      final result =
                                                                          await ProductService.deleteProduct(
                                                                              product: widget.product);
                                                                      Navigator.pop(
                                                                          context);
                                                                      if (result) {
                                                                        ProductService
                                                                            .getProduct();
                                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                            builder: (context) => ListPage(
                                                                                )));
                                                                      }

                                                                      // showDialog(context: context, builder: (_) {return AlertDialog(content: Center(child: CircularProgressIndicator()));});
                                                                      // await ProductService.deleteProduct(product: product);
                                                                      // Navigator.pop(context);
                                                                    },
                                                                    child: isLoading
                                                                        ? const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          )
                                                                        : Text('Delete', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: GoogleFonts.rubik().fontFamily)),
                                                                  ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      )
                    ]),
                  ],
                ),
              ),
            ),
          );
    // : SizedBox(
    //     width: double.infinity,
    //     height: 350,
    //     child: Card(
    //       elevation: 3,
    //       shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(15)),
    //       child: Column(
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               //  image user
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Container(
    //                       // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //                       // enable tooltip feature with role and image
    //                       // same as example 7
    //                       // but you can add parameter img = 'your_img'
    //                       // background color and initial name will be replaced with the image
    //                       child: SizedBox(
    //                         width: 35,
    //                         height: 35,
    //                         child: ProfilePicture(
    //                           name: widget.product.user.name,
    //                           radius: 31,
    //                           fontsize: 11,
    //                           tooltip: true,
    //                           count: 2,
    //                           // random: true,
    //                           // img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
    //                         ),
    //                       ),
    //                     ),
    //                     // Container(
    //                     //   width: 35,
    //                     //   height: 35,
    //                     //   decoration: BoxDecoration(
    //                     //     borderRadius: BorderRadius.circular(20),
    //                     //     image: DecorationImage(
    //                     //       image: Image.network(
    //                     //               'https://www.halojabar.com/wp-content/uploads/2023/01/Basmalah-Gralind.jpg')
    //                     //           .image,
    //                     //       fit: BoxFit.cover,
    //                     //     ),
    //                     //   ),
    //                     // ),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             widget.product.user.name,
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.w500,
    //                               fontSize: 16,
    //                               fontFamily:
    //                                   GoogleFonts.rubik().fontFamily,
    //                             ),
    //                           ),
    //                           Text(
    //                             '1 hour ago',
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                               color: Colors.grey,
    //                               fontFamily:
    //                                   GoogleFonts.rubik().fontFamily,
    //                             ),
    //                           ),
    //                         ]),
    //                   ],
    //                 ),
    //               ),
    //               //  text user
    //
    //               if (widget.isInProfile)
    //                 Align(
    //                   alignment: Alignment.topRight,
    //                   child: Column(
    //                     children: [
    //                       if (widget.product.user.id == user!.id)
    //                         PopupMenuButton<SampleItem>(
    //                           icon: Icon(
    //                             Icons.more_vert_outlined,
    //                             color: Colors.black,
    //                             size: 20,
    //                           ),
    //                           // Callback that sets the selected popup menu item.
    //                           // onSelected: onSelected,
    //                           onSelected: (value) {
    //                             if (value == SampleItem.edit) {
    //                               Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) => EditPage(
    //                                     product: widget.product,
    //                                   ),
    //                                 ),
    //                               );
    //                             }
    //                             if (value == SampleItem.delete) {
    //                               showDialog(
    //                                 context: context,
    //                                 builder: (context) => AlertDialog(
    //                                   title: Text('Delete'),
    //                                   content: Text(
    //                                       'Are you sure want to delete this item?'),
    //                                   actions: [
    //                                     TextButton(
    //                                       onPressed: () {
    //                                         Navigator.pop(context);
    //                                       },
    //                                       child: Text('Cancel',
    //                                           style: TextStyle(
    //                                               color:
    //                                                   HexColor('#3EB489'))),
    //                                     ),
    //                                     isLoading
    //                                         ? const Center(
    //                                       child: CircularProgressIndicator(),
    //                                     )
    //                                         :TextButton(
    //                                       onPressed: () async {
    //                                         FocusManager
    //                                             .instance?.primaryFocus
    //                                             ?.unfocus();
    //                                         final result =
    //                                             await ProductService
    //                                                 .deleteProduct(
    //                                                     product:
    //                                                         widget.product);
    //                                         Navigator.pop(context);
    //                                         if (result) {
    //                                           ProductService.getProduct();
    //                                           Navigator.of(context)
    //                                               .pushReplacement(
    //                                                   MaterialPageRoute(
    //                                                       builder: (context) =>
    //                                                           MainPage(
    //                                                             index: 0,)));
    //                                         }
    //
    //                                         // showDialog(context: context, builder: (_) {return AlertDialog(content: Center(child: CircularProgressIndicator()));});
    //                                         // await ProductService.deleteProduct(product: product);
    //                                         // Navigator.pop(context);
    //                                       },
    //                                       child: isLoading
    //                                           ? const Center(
    //                                         child: CircularProgressIndicator(),
    //                                       )
    //                                           :Text('Delete',
    //                                           style: TextStyle(
    //                                               color:
    //                                                   HexColor('#3EB489'))),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               );
    //                             }
    //                           },
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(15),
    //                           ),
    //                           itemBuilder: (BuildContext context) =>
    //                               <PopupMenuEntry<SampleItem>>[
    //                             const PopupMenuItem<SampleItem>(
    //                               value: SampleItem.edit,
    //                               child: Text('Edit Item'),
    //                             ),
    //                             PopupMenuItem<SampleItem>(
    //                               value: SampleItem.delete,
    //                               child: Text('Delete Item'),
    //                             ),
    //                           ],
    //                         ),
    //                     ],
    //                   ),
    //                 ),
    //             ],
    //           ),
    //           SizedBox(
    //             height: 2,
    //           ),
    //           InkWell(
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) =>
    //                       DetailPage(product: widget.product, user: widget.product.user,),
    //                 ),
    //               );
    //             },
    //             child: Card(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Stack(
    //                 children: <Widget>[
    //                   Container(
    //                     width: double.infinity,
    //                     height: 280,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(15),
    //                       image: DecorationImage(
    //                           image:
    //                               Image.network(widget.product.image).image,
    //                           fit: BoxFit.cover),
    //                     ),
    //                   ),
    //                   Container(
    //                     height: 280,
    //                     width: double.infinity,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(15),
    //                       gradient: LinearGradient(
    //                         begin: Alignment.topCenter,
    //                         end: Alignment.bottomCenter,
    //                         colors: [
    //                           Colors.transparent,
    //                           Colors.black.withOpacity(0.1),
    //                           Colors.black.withOpacity(0.2),
    //                           Colors.black.withOpacity(0.3),
    //                           Colors.black.withOpacity(0.7),
    //                           Colors.black.withOpacity(0.8),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   Positioned(
    //                     bottom: 15,
    //                     left: 15,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         SizedBox(
    //                           width: MediaQuery.of(context).size.width * 0.8,
    //                           child: Text(
    //                             widget.product.name,
    //                             overflow: TextOverflow.ellipsis,
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 24,
    //                               fontFamily: GoogleFonts.rubik().fontFamily,
    //                             ),
    //                           ),
    //                         ),
    //                         Text(
    //                           NumberFormat.currency(
    //                             locale: 'id-ID',
    //                             name: 'Rp ',
    //                             decimalDigits: 2,
    //                           ).format(widget.product.price).toString(),
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.w500,
    //                             fontSize: 14,
    //                             fontFamily: GoogleFonts.rubik().fontFamily,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
  }
}
