import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:url_launcher/url_launcher.dart';

import 'orders_screen.dart';


class OrderDialog extends StatelessWidget {
  final String orderId;
  OrderDialog({this.orderId});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = StoreAppCubit.get(context);
          var model=cubit.findByOrderId(orderId);
          return Directionality(
            textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Badge(
                        badgeColor: defaultColor,
                        animationType: BadgeAnimationType.slide,
                        toAnimate: true,
                        position: cubit.isEn
                            ? BadgePosition.topEnd(top: -10, end: 28)
                            : BadgePosition.topEnd(top: -6, end: -5),
                        badgeContent: Text(
                          StoreAppCubit.get(context)
                              .carts
                              .length
                              .toString(),
                          style: TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Feather.shopping_cart,
                            size: 25,
                            color: Theme.of(context).splashColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Badge(
                      badgeColor: defaultColor,
                      animationType: BadgeAnimationType.slide,
                      toAnimate: true,
                      position: cubit.isEn
                          ? BadgePosition.topEnd(top: -10, end: 28)
                          : BadgePosition.topEnd(top: -5, end: -3),
                      badgeContent: Text(
                        StoreAppCubit.get(context)
                            .wishList
                            .length
                            .toString(),
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      child: IconButton(
                        onPressed: () {
                          navigateTo(context, WishListScreen());
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 28,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                elevation: 0.0,
                backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(
                      cubit.getTexts('orderDialog1'),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.username}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog2'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.userAddress}',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog2'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),

                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.addressDetails}',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),

                          Text(
                            cubit.getTexts('orderDialog3'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.userPhone}',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog4'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.anotherNumber}',

                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog4'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Center(
                        child: Text(
                          cubit.getTexts('orderDialog5'),
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildProductsItem(context,model.prices[index]);
                              },
                              itemCount: model.prices.length,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildProductsItem(context,model.quantities[index]);
                              },
                              itemCount: model.quantities.length,
                            ),
                            flex: 1,
                          ),
                          SizedBox(width: 5.w,),
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildProductsItem(context,cubit.isEn ?model.productsEn[index]:model.products[index]);
                              },
                              itemCount: model.products.length,
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.subTotal}',

                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog6'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '10',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),

                          Text(
                            cubit.getTexts('orderDialog7'),

                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              '${model.total}',

                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
                            ),
                          ),
                          Spacer(),
                          Text(
                            cubit.getTexts('orderDialog8'),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp,color: defaultColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h,),
                      Container(
                        width: 89.w,
                        height: 6.h,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Icon(
                                  FontAwesome.whatsapp,
                                  color: Colors.green[700],
                                  size: 10.w,
                                ),
                                onTap: () => StoreAppCubit.get(context)
                                    .openWattsAppChat(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height *
                                    0.08,
                                child: RaisedButton(
                                  onPressed: () {
                                    launch("tel:+201093717500");
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: defaultColor,
                                    ),
                                  ),
                                  color: defaultColor,
                                  child: Text(
                                    cubit.getTexts('orderDialog10'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
  }

}
Widget buildProductsItem(context,model) => Text(
  '${model}',
  textAlign: TextAlign.end,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 13.sp),
);