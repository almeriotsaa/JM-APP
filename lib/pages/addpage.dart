import 'dart:developer';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jualmurahapp/helpers/common_helper.dart';
import 'package:jualmurahapp/model/user.dart';
import 'package:jualmurahapp/pages/homepage.dart';
import 'package:jualmurahapp/services/notification_service.dart';
import 'package:jualmurahapp/services/product_service.dart';

import 'mainpage.dart';

class AddPage extends StatefulWidget {
  final User? user;
  const AddPage({Key? key,  this.user}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  XFile? image;

  bool isLoading = false;

  bool isImageLoading = false;

  final _formKey = GlobalKey<FormState>();

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      locale: 'id-ID', decimalDigits: 0, symbol: 'Rp. '
  );

  @override
  void initState() {
    NotificationService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Color(0xffF5F5F5),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add Item',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: GoogleFonts.rubik().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.grey[600],
              // size: 20,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Item Name',
                      hintStyle:
                          TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _formatter
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Item Price',
                      hintStyle:
                          TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //create form for description
                  TextFormField(
                    controller: descriptionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Item Description',
                      hintStyle:
                          TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //  create card for image
                  Card(
                    color: Color(0xffF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    child: Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: image == null
                            ? Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              )
                            : isImageLoading?Center(child: CircularProgressIndicator(),) :ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                ),
                            )),
                  ),
                  const SizedBox(height: 20),
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 120,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('Choose Image Source',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily,
                                      )),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: HexColor('#3EB489'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            isImageLoading = true;
                                          });
                                          final XFile? image =
                                              await picker.pickImage(
                                                  source: ImageSource.camera);
                                          print(image!.path);
                                          final compressed = await CommonHelper.compressAndGetFile(image, image.path);
                                          setState(() {
                                            this.image = compressed;
                                            isImageLoading = false;
                                          });
                                        },
                                        icon: const Icon(Icons.camera_alt),
                                        label: Text('Camera',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: GoogleFonts.rubik()
                                                  .fontFamily,
                                            )),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: HexColor('#3EB489'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final XFile? image =
                                              await picker.pickImage(
                                                  source: ImageSource.gallery);
                                          print(image!.path);
                                          setState(() {
                                            this.image = image;
                                          });
                                        },
                                        icon: const Icon(Icons.folder),
                                        label: Text('Gallery',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: GoogleFonts.rubik()
                                                  .fontFamily,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        if (image == null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text('Please upload image'),
                              ),
                            );
                          return;
                        }
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
                        final itemName = nameController.text;
                        final itemPrice = priceController.text;
                        final itemDescription = descriptionController.text;

                        final formData = FormData.fromMap({
                          'name': itemName,
                          'price': _formatter.getUnformattedValue(),
                          'image': await MultipartFile.fromFile(image!.path),
                          'description': itemDescription,
                        });
                        final result =
                            await ProductService.addProduct(formData);
                        if(!mounted) return;
                        Navigator.pop(context);
                        await  NotificationService.showNotification( title: widget.user?.name ?? '', body: 'success added $itemName' , payload: 'MAIN');
                        setState(() {
                          isLoading = false;
                        });
                        if(!mounted)return;
                        if (result) {

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()), (_) => false);
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text('Gagal'),
                                  ));
                        }
                      },
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Save Item',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.rubik().fontFamily,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
