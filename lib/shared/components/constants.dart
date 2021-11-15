


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';

import 'components.dart';


void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
String token='';

class MyColors {
  static Color mainColor = Color(0xFF009603);
  static Color secondaryColor = Color(0xFF393236);
  static Color subTitle = Color(0xFF393236);
  static Color backgroundColor = Color(0xFF393236); //grey 300

  //Icon Colors
  static Color favColor = Color(0xFFF44336);
  static Color favBadgeColor = Color(0xFFE57373);
  static Color cartColor = Color(0xFF5E35B1);
  static Color cartBadgeColor = Color(0xFFBA68C8);

  //Gradients
  static Color gradientFStart = Color(0xFFE040FB);
  static Color gradientFEnd = Color(0xFFE1BEE7);
  static Color gradientLStart = Color(0xFFAA00FF);
  static Color gradientendLEnd = Color(0xFFAB47BC);

  static Color starterColor = Color(0xFF009603);
  static Color endColor = Color(0xFF56DA78);
  static Color endColor2 = Color(0xFFA0C2A9);
}
String uId='';
//a71
//fYSmObUQR8KKk1K9sLGKYU:APA91bEF1cC0IlQfldsMJpocIse8Eeuu-c-cBmFVibDavd98k1LeVEgS2zSV24rnpPTly9RuCK9f72HsH4aWfrCV_fVkpz1D7uP3fEAMA-bcti9EVwuy43p0FxsQsKRB3zRKwnwn8R8B
//y9
// d-X6s2PfRbKBsh05cOlL8Z:APA91bFVV2txIQPrAQ-XEq63vQWHAUejLvTWi0UuC9LHoe2_IFIkjrDbIOC_Kr-qP9js7apX56Ecgnk4wdqH3TGl8Ix5LnpZrkW5-vgAUDz5rrIxIN12J9tc8i8T1ICSZBEhowUxuvQa