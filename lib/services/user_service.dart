import 'package:dio/dio.dart';
import 'package:jualmurahapp/model/user.dart';

import '../config/api_config.dart';
import '../local/secure_storage.dart';

final dio = Dio();

class UserService {
  UserService._();

//  update user
  static Future<bool> updateUser({
    required User user,
    required FormData form,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.updateUserEndpoint}/${user
          .id}';

      final token = await SecureStorage.getToken();
      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await dio.post(
          url, data: form, options: Options(headers: header));
      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['data']);
        await SecureStorage.updateUser(user);
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