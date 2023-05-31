import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CommonHelper{
  static Future<XFile?> compressAndGetFile(XFile file, String targetPath) async {


    try {
      final filePath = file.path  ;

      // Create output file path
      // eg:- "Volume/VM/abcd_out.jpeg"
      final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.path, outPath,
        quality: 40,
      );

      return result;
    } on UnsupportedError catch (e) {
      rethrow;
    }catch(e){
      rethrow;
    }

  }
}