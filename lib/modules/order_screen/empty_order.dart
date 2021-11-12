import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/modules/feeds_screen/feeds_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

class EmptyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = StoreAppCubit.get(context);
    return Directionality(
        textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
        child: Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Text(''),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Empty.png'),
              ),
            ),
          ),
          Text(
            cubit.getTexts('orderEmpty1'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              cubit.getTexts('orderEmpty2'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14.sp),
            ),),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.06,
            child: RaisedButton(
              onPressed: () {
                navigateTo(context, FeedsScreen());
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: defaultColor),
              ),
              color: defaultColor,
              child: Text(
                cubit.getTexts('cartEmpty3'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
    ));
  }
}
