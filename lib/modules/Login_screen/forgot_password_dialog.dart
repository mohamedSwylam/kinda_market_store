import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/modules/Login_screen/login_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';


class ForgotPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = StoreAppCubit.get(context);
        return Directionality(
          textDirection: cubit.isEn? TextDirection.ltr :TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5.h,),
                      Image.asset(
                        'assets/images/ok.png',
                      ),
                      SizedBox(height: 4.h,),
                      Text(
                        cubit.getTexts('forgetPassDialog1'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.w600,fontSize: 15.sp),),
                      SizedBox(height: 4.h,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text(
                          cubit.getTexts('forgetPassDialog2'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.w600,fontSize: 12.sp),),
                      ),

                      SizedBox(height: 4.h,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: RaisedButton(
                          onPressed:  ()  {
                            StoreAppCubit.get(context).selectedHome();
                            navigateTo(context, LoginScreen()
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: defaultColor),
                          ),
                          color: defaultColor,
                          child: Text(
                            cubit.getTexts('forgetPassDialog3'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h,),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

}
