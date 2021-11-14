import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CartModel {
  String productId;
  String cartId;
  String userId;
  String title;
  String titleEn;
  double price;
  String imageUrl;
  int quantity;

  CartModel(
      {this.userId,
      this.cartId,
      this.title,
      this.titleEn,
      this.price,
      this.imageUrl,
      this.quantity,
      this.productId});

  CartModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    titleEn = json['titleEn'];
    productId = json['productId'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    quantity = json['quantity'];
    cartId = json['cartId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'title': title,
      'titleEn': titleEn,
      'userId': userId,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'productId': productId,
    };
  }
}

