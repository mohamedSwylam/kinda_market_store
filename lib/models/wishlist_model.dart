import 'package:flutter/material.dart';

class WishListModel {
  String productId;
  String wishListId;
  String userId;
  String title;
  String titleEn;
  double price;
  String imageUrl;

  WishListModel(
      {this.userId,
        this.wishListId,
        this.title,
        this.titleEn,
        this.price,
        this.imageUrl,
        this.productId});

  WishListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    titleEn = json['titleEn'];
    productId = json['productId'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    wishListId = json['wishListId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'wishListId': wishListId,
      'title': title,
      'titleEn': titleEn,
      'userId': userId,
      'price': price,
      'imageUrl': imageUrl,
      'productId': productId,
    };
  }
}