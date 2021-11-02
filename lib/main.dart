import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinda_store/modules/Login_screen/login_screen.dart';
import 'package:kinda_store/modules/sign_up_screen/cubit/cubit.dart';
import 'package:kinda_store/modules/sign_up_screen/sign_up_screen.dart';
import 'package:kinda_store/shared/bloc_observer.dart';
import 'package:kinda_store/shared/components/constants.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:kinda_store/shared/network/remote/dio_helper.dart';
import 'package:kinda_store/shared/styles/themes.dart';

import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'layout/store_layout.dart';
import 'modules/landingPage/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  Widget widget;
  if (uId != null) {
    widget = StoreLayout();
  } else {
    widget = LandingPage();
  }

  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  runApp(MyApp(isDark: isDark,startWidget: widget,));
}

class MyApp extends StatelessWidget
{

  final bool isDark;
  final Widget startWidget;
  MyApp({this.startWidget,this.isDark});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => StoreAppCubit()..changeThemeMode(fromShared: isDark)..getProduct()..getUserData()..getOrders()..getWishList()..getCarts(),
        ),
      ],
      child: BlocConsumer<StoreAppCubit,StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: StoreAppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: LandingPage(),
          );
        },
      ),
    );
  }
}