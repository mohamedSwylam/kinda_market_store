import 'package:flutter/material.dart';

class OrderModel {
  String orderId;
  String title;
  String productId;
  double price;
  String imageUrl;
  String userId;
  String username;
  String userAddress;
  String anotherNumber;
  double subTotal;
  String addressDetails;
  int quantity;
  double total;
  String userPhone;

  OrderModel(
      {this.orderId,
        this.title,
        this.productId,
        this.imageUrl,
        this.userId,
        this.username,
        this.userAddress,
        this.addressDetails,
        this.quantity,
        this.anotherNumber,
        this.subTotal,
        this.total,
        this.price,
        this.userPhone,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    userId = json['userId'];
    username = json['username'];
    userAddress = json['userAddress'];
    addressDetails = json['addressDetails'];
    anotherNumber = json['anotherNumber'];
    imageUrl = json['imageUrl'];
    quantity = json['quantity'];
    title = json['title'];
    userPhone = json['userPhone'];
    price = json['price'];
    total = json['total'];
    subTotal = json['subTotal'];
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'userId': userId,
      'title': title,
      'username': username,
      'quantity': quantity,
      'userAddress': userAddress,
      'addressDetails': addressDetails,
      'anotherNumber': anotherNumber,
      'imageUrl': imageUrl,
      'subTotal': subTotal,
      'total':total,
      'price':price,
      'userPhone':userPhone,
    };
  }
}