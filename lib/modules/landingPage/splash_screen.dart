import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/modules/landingPage/landing_page.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/widget/fade_animation.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration( seconds : 5),() => navigateAndFinish(context, LandingPage()));
    var cubit = StoreAppCubit.get(context);
    return Directionality(
      textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            FadeAnimation(1.2,Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.yellow[700],
              ),
            ),),
            FadeAnimation(1.5,Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 15.h,
                    width: 34.w,
                    child: Image(
                      image: AssetImage('assets/images/login.png'),
                    ),
                  ),
                  SizedBox(height: 4.h,),
                  Text(
                    cubit.getTexts('login1'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold,fontSize: 18.sp,color: Colors.black),
                  ),
                ],
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
