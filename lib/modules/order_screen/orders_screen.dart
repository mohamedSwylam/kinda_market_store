import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/order_model.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';
import 'empty_order.dart';
class OrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = StoreAppCubit.get(context);
          return  StoreAppCubit.get(context).orders.isEmpty
              ? Scaffold(
            body: EmptyOrder(),
          )
              :Directionality(
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
                        position: StoreAppCubit.get(context).isEn ?BadgePosition.topEnd(top: -10, end: 28):BadgePosition.topEnd(top: -6, end: -5),
                        badgeContent: Text(
                          StoreAppCubit.get(context).carts.length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15.sp),
                        ),
                        child: IconButton(
                          onPressed: () {
                            StoreAppCubit.get(context).selectedCart();
                          },
                          icon: Icon(
                            Feather.shopping_cart,
                            size: 7.w,
                            color: Theme.of(context).splashColor,
                          ),
                        ),
                      ),
                    ),
                    Badge(
                      badgeColor: defaultColor,
                      animationType: BadgeAnimationType.slide,
                      toAnimate: true,
                      position: StoreAppCubit.get(context).isEn ?BadgePosition.topEnd(top: -10, end: 28):BadgePosition.topEnd(top: -5, end: -3),
                      badgeContent: Text(
                        StoreAppCubit.get(context).wishList.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      child: IconButton(
                        onPressed: () {
                          navigateTo(context, WishListScreen());
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 7.w,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      '${cubit.getTexts('order1')} (${StoreAppCubit.get(context).orders.length})',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                ],
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list=StoreAppCubit.get(context).orders;
                    return buildOrderItem(context,list[index]);
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 8,
                  ),
                  itemCount: StoreAppCubit.get(context).orders.length,
                ),
            ),
          ),
              );

        });
  }
}

Widget buildOrderItem(context ,OrderModel orderModel) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.h,),
                      Text(
                        cubit.isEn?orderModel.titleEn:orderModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                cubit.getTexts('cart2'),
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                '${orderModel.total}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize:13.0.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5.w,),
                          Text(
                            cubit.getTexts('orderDetails4'),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        cubit.getTexts('order2'),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Container(
                  width: 35.w,
                  height: 29.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        '${orderModel.imageUrl}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        margin: const EdgeInsets.only(
            left: 10, bottom: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).backgroundColor,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
    ),
  );
}
