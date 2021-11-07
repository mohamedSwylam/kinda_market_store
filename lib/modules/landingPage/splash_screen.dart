import 'dart:async';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/modules/landingPage/landing_page.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/widget/fade_animation.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        Timer(Duration( seconds : 5),()=>navigateTo(context, LandingPage()));
        return Scaffold(
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
                      'Kinda Cheese',
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
        );
      },
    );
  }
}
