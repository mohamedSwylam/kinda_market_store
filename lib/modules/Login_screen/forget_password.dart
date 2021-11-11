
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/widget/fade_animation.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'forgot_password_dialog.dart';

class ForgetPasswordScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ForgotPasswordDialog(),
          );
          emailController.clear();
        }
      },
      builder: (context, state) {
        var cubit = StoreAppCubit.get(context);
        return Directionality(
          textDirection: cubit.isEn? TextDirection.ltr :TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1,
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [Colors.amber, Colors.teal],
                            [Colors.amberAccent, Colors.green[100]],
                          ],
                          durations: [19440, 10800],
                          heightPercentages: [0.20, 0.25],
                          blur: MaskFilter.blur(BlurStyle.solid, 10),
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        waveAmplitude: 0,
                        size: Size(
                          double.infinity,
                          double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        FadeAnimation(0.9,Center(
                          child: Container(
                            height: 17.h,
                            width: 35.w,
                            child: Image(
                              image: AssetImage('assets/images/login.png'),
                            ),
                          ),
                        ),),
                        SizedBox(
                          height: 8.h,
                        ),
                        Center(
                          child: FadeAnimation(
                            1.2,
                            Text(
                              cubit.getTexts('forgetPass1'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.bold,fontSize: 25.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        FadeAnimation(
                            1.5,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.white))),
                                      child: defaultFormFiled(
                                          type: TextInputType.emailAddress,
                                          controller: emailController,
                                          validate: (String value) {
                                            if (value.isEmpty ||
                                                !value.contains('@')) {
                                              return '${cubit.getTexts('forgetPass4')}';
                                            }
                                            return null;
                                          },
                                          hint: cubit.getTexts('forgetPass2'),),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 3.h,
                        ),
                        FadeAnimation(
                            1.8,
                            Center(
                              child:  ConditionalBuilder(
                                condition: state is! LoginLoadingState,
                                builder: (context) {
                                  return InkWell(
                                    onTap: () {
                                      if (formKey.currentState.validate()) {
                                        StoreAppCubit.get(context).userForgetPassword(
                                          email: emailController.text,
                                        );
                                      }

                                    },
                                    child: Container(
                                      width: 32.w,
                                      height: 11.h,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.yellow[700]),
                                      child: Center(
                                          child: Text(
                                            cubit.getTexts('forgetPass3'),
                                            style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.sp),
                                          )),
                                    ),
                                  );
                                },
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator()),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
