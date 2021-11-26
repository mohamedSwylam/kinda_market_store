import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/modules/Login_screen/login_screen.dart';
import 'package:kinda_store/modules/phone_sign_in/phone_verifcation.dart';
import 'package:kinda_store/modules/phone_sign_in/phone_login.dart';
import 'package:kinda_store/modules/sign_up_screen/sign_up_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

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
  var loading = false;

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
    var cubit = StoreAppCubit.get(context);
    return Directionality(
      textDirection:
          cubit.isEn == false ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          body: Stack(children: [
        CachedNetworkImage(
          errorWidget: (context, child, progress) {
            return progress == null
                ? child
                : SpinKitChasingDots(
                    size: 50,
                    color: defaultColor,
                  );
          },
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
                cubit.getTexts('landing1'),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  cubit.getTexts('landing2'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
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
                            cubit.getTexts('landing3'),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15.sp),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Icon(
                            Feather.user,
                            size: 6.w,
                          )
                        ],
                      )),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink.shade400),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: ColorsConsts.backgroundColor),
                            ),
                          )),
                      onPressed: () {
                        navigateTo(context, SignUpScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cubit.getTexts('landing4'),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Feather.user_plus,
                            size: 6.w,
                          )
                        ],
                      )),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(
              height: 6.h,
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
                  height: 7.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      cubit.getTexts('landing5'),
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
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
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    StoreAppCubit.get(context).logInWithFacebook(context);
                  },
                  color: Colors.blue[900],
                  iconSize: 11.w,
                  icon: Icon(
                    FontAwesome.facebook_square,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    StoreAppCubit.get(context).googleSignIn(context);
                  },
                  color: Colors.redAccent,
                  iconSize: 12.w,
                  icon: Icon(
                    FontAwesome.google_plus_official,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    navigateTo(context, PhoneLoginScreen());
                  },
                  color: Colors.green[700],
                  iconSize: 12.w,
                  icon: Icon(
                    FontAwesome.phone_square,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    StoreAppCubit.get(context).userLoginAnonymous(context);
                  },
                  child: Container(
                    height: 7.h,
                    width: 33.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                        cubit.getTexts('landing6'),
                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
          ],
        ),
      ])),
    );
  }
}
