import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jualmurahapp/config/api_config.dart';
import 'package:jualmurahapp/model/product.dart';

import '../local/secure_storage.dart';

final dio = Dio();

class ProductService {
  ProductService._();

  static Future<List<Product>?> getProduct({
    String? search,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}';
      final token = await SecureStorage.getToken();

      final header = {
        'Authorization': 'Bearer $token',
      };

      final query = {
        if (search != null) 'search': search,
      };
      log(query.toString());
      log(header.toString());
      log(token.toString());
      final response = await dio.get(
        url,
        options: Options(headers: header),
        queryParameters: query,
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final products = data.map((e) => Product.fromJson(e)).toList();
        return products;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<List<Product>?> getProductUser() async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}/user';
      final token = await SecureStorage.getToken();

      final header = {
        'Authorization': 'Bearer $token',
      };
      log(header.toString());
      log(token.toString());
      final response = await dio.get(url, options: Options(headers: header));
      log(response.data.toString());

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final products = data.map((e) => Product.fromJson(e)).toList();
        return products;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<List<Product>?> getProductById({
    required Product product,
    required String id,
  }) async {
    try {
      final url = Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}/${product.id}');

      final response = await dio.get(url as String);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final products = data.map((e) => Product.fromJson(e)).toList();
        return products;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<bool> addProduct(FormData form) async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}';

      log(url.toString());
      final token = await SecureStorage.getToken();

      final response = await dio.post(url,
          data: form,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e);
    }
  }

//  updateproduct
  static Future<bool> updateProduct({
    required Product product,
    required FormData form,
  }) async {
    try {
      final url =
          '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}/${product.id}';

      final token = await SecureStorage.getToken();

      final response = await dio.post(url,
          data: form,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
            'Authorization': 'Bearer $token',
          }));

      log('${response.statusCode}');
      log('${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
      log('${e.response!.statusCode}');
      log('${e.response!.data}');
      return false;
    }
  }

//  deleteproduct
  static Future<bool> deleteProduct({
    required Product product,
  }) async {
    try {
      final url =
          '${ApiConfig.baseUrl}${ApiConfig.productEndpoint}/${product.id}';

      final response = await dio.delete(url);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
