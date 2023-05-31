import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jualmurahapp/local/secure_storage.dart';
import 'package:jualmurahapp/model/user.dart';

import '../config/api_config.dart';

final dio = Dio();

class AuthService {
  AuthService._();

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}';
      final data = {
        'email': email,
        'password': password,
      };
      final response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        final responseJson = response.data;
        log(responseJson.toString());
        final status = responseJson['success'];
        if (status == true) {
          final token = responseJson['data']['access_token'];
          log(token.toString());
          final user = User.fromJson(responseJson['data']['user']);
          //  chace user dan token
          await SecureStorage.cacheToken(token: token);
          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioError catch (e) {
      log('${e.response!.statusCode} ${e.response!.data}');
      return false;
    }
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String numberPhone,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}';
      final data = {
        'name': name,
        'email': email,
        'number_phone': numberPhone,
        'password': password,
      };
      log(data.toString());
      final response = await dio.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final responseJson = response.data;
        final status = responseJson['success'];
        if (status == true) {
          final token = responseJson['access_token'];
          final user = User.fromJson(responseJson['data']);
          // ! Cache User dan token
          await SecureStorage.cacheToken(token: token);
          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioError catch (e) {
      log('${e.response?.data}');
      throw Exception(e);
    }
  }

  static Future<bool> logout() async {
    try {
      const url = '${ApiConfig.baseUrl}${ApiConfig.logoutEndpoint}';
      final token = await SecureStorage.getToken();
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.post(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final responseJson = response.data;
        final status = responseJson['success'];
        if (status == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

}
