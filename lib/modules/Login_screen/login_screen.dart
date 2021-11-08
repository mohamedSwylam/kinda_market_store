import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/widget/fade_animation.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'forget_password.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(text: state.error, state: ToastState.ERROR);
        }
        if (state is LoginSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            navigateAndFinish(context, StoreLayout());
          });
          StoreAppCubit.get(context).selectedHome();
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                            'Kinda Cheese',
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
                                                color: Colors.grey[300]))),
                                    child: defaultFormFiled(
                                        type: TextInputType.emailAddress,
                                        onSubmit: (){},
                                        controller: emailController,
                                        validate: (String value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return 'بريد الكتروني غير صالح';
                                          }
                                          return null;
                                        },
                                        hint: 'ادخل البريد الالكتروني'),

                                  ),
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: defaultFormFiled(
                                        type: TextInputType.visiblePassword,
                                        controller: passwordController,
                                        onSubmit: (){},
                                        validate: (String value) {
                                          if (value.isEmpty || value.length < 7) {
                                            return 'كلمه المرور غير صالحه';
                                          }
                                          return null;
                                        },
                                        isPassword: StoreAppCubit.get(context).isPasswordShown,
                                        suffixPressed: () {
                                          StoreAppCubit.get(context)
                                              .changePasswordVisibility();
                                        },
                                        prefix: StoreAppCubit.get(context).prefix,
                                        hint: 'ادخل كلمه المرور'
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  FadeAnimation(1.8, Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Container(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                navigateTo(context,ForgetPasswordScreen());
                              },
                              child: Text(
                                'نسيت كلمه المرور ؟',
                                style: TextStyle(color: Colors.black,fontSize: 13.sp),
                              ),
                            )),
                      ),),
                      SizedBox(
                        height: 3.h,
                      ),
                      FadeAnimation(
                          2.1,
                          Center(
                            child:  ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) {
                                return InkWell(
                                  onTap: () {
                                    if (formKey.currentState.validate()) {
                                      StoreAppCubit.get(context).userLogin(
                                        password: passwordController.text,
                                        email: emailController.text,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 30 .w,
                                    height: 11.h,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.yellow[700]),
                                    child: Center(
                                        child: Text(
                                          "دخول",
                                          style: TextStyle(
                                              color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp),
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
        );
      },
    );
  }
}
