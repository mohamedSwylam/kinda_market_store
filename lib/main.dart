import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/modules/landingPage/splash_screen.dart';
import 'package:kinda_store/modules/phone_sign_in/phone_login.dart';
import 'package:kinda_store/shared/bloc_observer.dart';
import 'package:kinda_store/shared/components/constants.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:kinda_store/shared/network/remote/dio_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/shared/styles/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'layout/store_layout.dart';
import 'modules/landingPage/landing_page.dart';
import 'modules/phone_sign_in/phone_verifcation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token =await FirebaseMessaging.instance.getToken();
  print(token);
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  Widget widget;
  if (uId != null) {
    widget = StoreLayout();
  } else {
    widget = SplashScreen();
  }

  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  bool isEn = CacheHelper.getBoolean(key: 'isEn');
  runApp(MyApp(isDark: isDark,startWidget: widget,isEn: isEn,),);}
class MyApp extends StatelessWidget
{
  final bool isDark;
  final bool isEn;
  final Widget startWidget;
  MyApp({this.startWidget,this.isDark,this.isEn});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => StoreAppCubit()..changeThemeMode(fromShared: isDark)..getProduct()..getWatchedProducts()..getUserData()..getOrders()..getWishList()..getCarts()..getBanners()..changeLanguage(fromShared: isEn)..getLan()),
      ],
      child: BlocConsumer<StoreAppCubit,StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Sizer(
            builder: (context, orientation, deviceType)=> MaterialApp(
              builder: DevicePreview.appBuilder,
              title: 'Kinda Store',
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              theme: lightTheme,
              themeMode: StoreAppCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark,
              home: startWidget,
            ),
          );
        },
      ),
    );
  }
}
//  runApp(DevicePreview(builder: (context) =>MyApp(isDark: isDark,startWidget: widget,isEn: isEn,),));} runApp(MyApp(isDark: isDark,startWidget: widget,isEn: isEn,),);}
