import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:uuid/uuid.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class PhoneVerficationScreen extends StatelessWidget {
  final String phone;
  final String name;
  final String address;
  final String password;
  final  String profile;

  PhoneVerficationScreen({this.phone, this.name, this.address, this.password,this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {
        if (state is PhoneSignInErrorState) {
          showToast(text: state.error, state: ToastState.ERROR);
        }
        if (state is PhoneSignInSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            navigateAndFinish(context, StoreLayout());
          });
          StoreAppCubit.get(context).selectedHome();
        }
      },
      builder: (context, state) {
        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate =
            "${dateparse.day}-${dateparse.month}-${dateparse.year}";
        var profileImage = StoreAppCubit.get(context).profile;
        var uuid = Uuid();
        var cubit = StoreAppCubit.get(context);
        return Directionality(
          textDirection:
              cubit.isEn == false ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1.15,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        cubit.getTexts('phone1'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 25.sp),
                      ),
                      Text(
                        '${phone}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                            letterSpacing: 5),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.sp,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            Text(
                              cubit.getTexts('phone2'),
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.sp,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        width: 100.w,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: OTPTextField(
                            length: 6,
                            fieldWidth: 35,
                            otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Colors.white,
                              borderColor: Colors.white,
                              disabledBorderColor: Colors.white,
                              enabledBorderColor: Colors.white,
                              errorBorderColor: Colors.white,
                              focusBorderColor: Colors.white,
                            ),
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.black),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) => cubit.onPinCompleted(pin),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            cubit.signInwithPhoneNumber(
                              verificationId: cubit.verificationIdFinal,
                              smsCode: cubit.smsCode,
                              context: context,
                              password: password,
                              name: name,
                              address: address,
                              phone: phone,
                              joinedAt: formattedDate,
                              createdAt: Timestamp.now().toString(),
                              profileImage: profile,);
                          },
                          child: Container(
                            width: 30.w,
                            height: 11.h,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.yellow[700]),
                            child: Center(
                                child: Text(
                                  cubit.getTexts('login5'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                    ],
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
