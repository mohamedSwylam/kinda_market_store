import 'package:flutter/material.dart';

class BannerModel with ChangeNotifier{
  String id;
  String imageUrl;
  BannerModel({this.id, this.imageUrl});
  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': id,
      'imageUrl': imageUrl,
    };
  }
}