import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/modules/Login_screen/login_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';


class ForgotPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Dialog(
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
                    SizedBox(height: 20,),
                    Image.asset(
                      'assets/images/ok.png',
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'تم ارسال رابط اعاده تعيين كلمه المرور بنجاح',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w600,fontSize: 15),),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        'برجاء التوجه الي صندوق الوارد بالبريد الالكتروني الخاص بكم لاعاده تعيين كلمه المرور الخاصه بكم ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.w600,fontSize: 15),),
                    ),

                    SizedBox(height: 20,),
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
                          'عوده',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

}
