import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true,
      ),
    );
  }


  static Future<Response> postData({
    @required String url,
    Map<String, dynamic> query,
    @required Map<String, dynamic> data,
    String token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAlf5cfKg:APA91bFnumlsHjmG5VO-C3EYoXr-7YNX4WfPasuCrz-ZYTkx2y46U7DNYDIE_TiJGXGfl1660tI4YlhthE15kx5ie5oOzuCSmYWN1CYgT8X2gP7IZBcwZDB1gj-Hsy5AvBBeYHoXgri7',
    };
    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}