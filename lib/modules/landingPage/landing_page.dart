import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/modules/Login_screen/login_screen.dart';
import 'package:kinda_store/modules/sign_up_screen/cubit/cubit.dart';
import 'package:kinda_store/modules/sign_up_screen/sign_up_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/landing2.jpg?alt=media&token=a37ab651-f204-459d-b5bf-5558bf605859',
    'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/landing3.jpg?alt=media&token=bfc0db89-0b69-452a-a431-6f448aa7a8e0',
    'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/landing5.jpg?alt=media&token=cc4e1f1e-2649-4175-b6f0-7135bc466319',
  ];
  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          CachedNetworkImage(
            imageUrl: images[1],
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'مرحبا',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '   مرحبا بكم في كنده تشيز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: ColorsConsts.backgroundColor),
                              ),
                            )),
                        onPressed: () {
                          navigateTo(context, LoginScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'دخول',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Feather.user,
                              size: 18,
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade400),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side:
                                BorderSide(color: ColorsConsts.backgroundColor),
                              ),
                            )),
                        onPressed: () {
                          navigateTo(context, SignUpScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'انشاء حساب',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Feather.user_plus,
                              size: 18,
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                        'او يمكنك استخدام',
                        style: TextStyle(color: Colors.white,fontSize: 15),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    color: Colors.blue[900],
                    iconSize: 40,
                    icon: Icon(
                      FontAwesome.facebook_square,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      StoreAppCubit.get(context).googleSignIn(context);
                    },
                    color: Colors.redAccent,
                    iconSize: 45,
                    icon: Icon(
                      FontAwesome.google_plus_official,
                    ),
                  ),
                  SizedBox(width: 25,),
                  InkWell(
                    onTap: (){
                      StoreAppCubit.get(context).userLoginAnonymous(context);
                    },
                    child: Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text(
                          'الدخول كذائر',
                          style: TextStyle(color: Colors.white,fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ]));
  }
}