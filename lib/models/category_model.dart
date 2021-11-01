import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier{
  final String categoryName;
  final String categoryImage;
  CategoryModel({this.categoryName, this.categoryImage});

}