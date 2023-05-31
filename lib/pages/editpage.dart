import 'dart:developer';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jualmurahapp/model/product.dart';
import 'package:jualmurahapp/pages/mainpage.dart';
import 'package:jualmurahapp/pages/profilepage.dart';

import '../services/product_service.dart';
import 'homepage.dart';

class EditPage extends StatefulWidget {
  final Product product;
  const EditPage({Key? key, required this.product}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  XFile? image;

  bool isLoading = false;

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      locale: 'id-ID', decimalDigits: 0, symbol: 'Rp. '
  );

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toString();
    descriptionController.text = widget.product.description;
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Item',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.rubik().fontFamily,
          ),
        ),
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        //  icon button
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainPage(index: 2,)));
            },
            icon:  Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
              size: 20,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
                style: TextStyle(
                    fontSize: 14, fontFamily: GoogleFonts.rubik().fontFamily),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  labelText: 'Item Name',
                  hintStyle:
                      TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                ),
              ),
              // TextFormField(
              //   style: TextStyle(fontSize: 14),
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Item Name',
              //   ),
              // ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _formatter
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter item price';
                  }
                  return null;
                },
                style: TextStyle(
                    fontSize: 14, fontFamily: GoogleFonts.rubik().fontFamily),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  labelText: 'Item Price',
                  hintStyle:
                      TextStyle(fontFamily: GoogleFonts.rubik().fontFamily),
                ),
              ),
              const SizedBox(height: 20),
              // form for description
              TextFormField(
                controller: descriptionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter item description';
                  }
                  return null;
                },
                style: TextStyle(
                    fontSize: 14, fontFamily: GoogleFonts.rubik().fontFamily),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                    width: double.infinity,
                    height: 280,
                    child: image == null
                        ? Image.network(widget.product.image, fit: BoxFit.cover)
                        : Image.file(File(image!.path), fit: BoxFit.cover)),
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
                                          GoogleFonts.rubik().fontFamily)),
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
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        print(image!.path);
                                        setState(() {
                                          this.image = image;
                                        });
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                      label: Text(
                                        'Camera',
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.rubik().fontFamily),
                                      )),
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
                                      label: Text(
                                        'Gallery',
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.rubik().fontFamily),
                                      )),
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
                        fontFamily: GoogleFonts.rubik().fontFamily),
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
                      'price': _formatter.getUnformattedValue(),
                      'description': descriptionController.text,
                    };
                    if (image != null) {
                      final imageFile = await MultipartFile.fromFile(
                          image!.path,
                          filename: image!.path);
                      mapData['image'] = imageFile;
                    }
                    log('mapData $mapData');

                    final formData = FormData.fromMap(mapData);
                    final result = await ProductService.updateProduct(
                        product: widget.product, form: formData);
                    Navigator.pop(context);
                    setState(() {
                      isLoading = false;
                    });
                    if (result) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MainPage(
                                index: 2,
                              )));
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
                              fontFamily: GoogleFonts.rubik().fontFamily),
                        ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
