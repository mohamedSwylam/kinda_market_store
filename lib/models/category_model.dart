import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier{
  final String categoryName;
  final String categoryImage;
  final String categoryId;
  CategoryModel({this.categoryName, this.categoryImage,this.categoryId});
}