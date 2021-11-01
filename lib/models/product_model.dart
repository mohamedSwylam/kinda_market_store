import 'package:flutter/material.dart';

class Product {
   String id;
   String title;
   String description;
   double price;
   String imageUrl;
   String productCategoryName;
   bool isPopular;
   int quantity;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.imageUrl,
        this.productCategoryName,
        this.isPopular,
        this.quantity,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    productCategoryName = json['productCategoryName'];
    isPopular = json['isPopular'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'productCategoryName': productCategoryName,
      'isPopular': isPopular,
      'quantity': quantity,
    };
  }
}