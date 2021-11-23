import 'package:flutter/material.dart';

class OrderModel {
  String orderId;
  String title;
  String titleEn;
  String imageUrl;
  List products;
  List prices;
  List quantities;
  List productsEn;
  String userId;
  String username;
  String userAddress;
  String anotherNumber;
  double subTotal;
  String addressDetails;
  double total;
  String userPhone;

  OrderModel(
      {this.orderId,
        this.title,
        this.titleEn,
        this.products,
        this.imageUrl,
        this.prices,
        this.quantities,
        this.productsEn,
        this.userId,
        this.username,
        this.userAddress,
        this.addressDetails,
        this.anotherNumber,
        this.subTotal,
        this.total,
        this.userPhone,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    products = json['products'];
    userId = json['userId'];
    quantities = json['quantities'];
    titleEn = json['titleEn'];
    prices = json['prices'];
    productsEn = json['productsEn'];
    username = json['username'];
    userAddress = json['userAddress'];
    addressDetails = json['addressDetails'];
    anotherNumber = json['anotherNumber'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    userPhone = json['userPhone'];
    total = json['total'];
    subTotal = json['subTotal'];
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'quantities': quantities,
      'products': products,
      'productsEn': productsEn,
      'title': title,
      'titleEn': titleEn,
      'username': username,
      'prices': prices,
      'userAddress': userAddress,
      'addressDetails': addressDetails,
      'anotherNumber': anotherNumber,
      'imageUrl': imageUrl,
      'subTotal': subTotal,
      'total':total,
      'userPhone':userPhone,
    };
  }
}