import 'package:flutter/material.dart';

class BrandModel with ChangeNotifier{
  final String brand;
  final String brandImage;
  final int id;
  BrandModel({this.brand, this.brandImage,this.id});
}