
import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/cart_model.dart';
import 'package:kinda_store/modules/order_screen/order_details_screen.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart';

import 'empty_cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return StoreAppCubit.get(context).carts.isEmpty
              ? Scaffold(
            body: EmptyCart(),
          )
              : Scaffold(
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
                      position: BadgePosition.topEnd(top: -6, end: -5),
                      badgeContent: Text(
                        StoreAppCubit.get(context).carts.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                  SizedBox(width: 3.w,),
                  Badge(
                    badgeColor: defaultColor,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: -5, end: -3),
                    badgeContent: Text(
                      StoreAppCubit.get(context).wishList.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Text(
                    "العربه (${StoreAppCubit.get(context).carts.length})",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                ),
              ],
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list=StoreAppCubit.get(context).carts;
                    return buildCartItem(list[index],context);
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 4.w,
                  ),
                  itemCount: StoreAppCubit.get(context).carts.length,
                ),
              ),
            ),
            // bottomSheet: bottomSheet(context),
          );
        });
  }
}
Widget buildCartItem(CartModel model,context) => InkWell(
  onTap: () {
   /* navigateTo(
        context,
        ProductDetails(
          productId: model.productId,
        ));*/
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
      height: 60.h,
      width: 80.w,
      child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            '${model.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 20,
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
                                    'ج.م',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Text(
                                    '${model.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '  :  السعر',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
                                    'ج.م',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Text(
                                    '${(model.price*model.quantity).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '  : السعر الكلي ',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      flex: 3,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0,right: 10),
                        child: Container(
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                '${model.imageUrl}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: CircleAvatar(
                              radius: 5.w,
                              backgroundColor: defaultColor,
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.black,
                                size: 7.w,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (model.quantity > 0) {
                              StoreAppCubit.get(context).reduceItemByOne(
                                imageUrl: model.imageUrl,
                                price:  model.price,
                                title: model.title,
                                productId: model.productId,
                                quantity: ( model.quantity-1),
                                userId:  model.userId,
                                cartId: model.cartId,
                              );
                            }
                          },
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                              child: Text(
                                '${model.quantity.toString()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black,fontSize: 18.sp),
                              )),

                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          child: Container(
                            child: CircleAvatar(
                              radius: 5.w,
                              backgroundColor: defaultColor,
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.black,
                                size: 7.w,
                              ),
                            ),
                          ),
                          onTap: () {
                            StoreAppCubit.get(context).addItemByOne(
                              imageUrl: model.imageUrl,
                              price:  model.price,
                              title: model.title,
                              productId: model.productId,
                              quantity: ( model.quantity+1),
                              userId:  model.userId,
                              cartId: model.cartId,
                            );
                          },
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '  : الكميه ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 80.w,
                        height: 6.h,
                        child: RaisedButton(
                          onPressed: StoreAppCubit.get(context)
                              .orders.any((element) => element.productId==model.productId)
                              ? () {}
                              : () {
                            navigateTo(
                                context,
                                OrderDetailsScreen(
                                  price: model.price,
                                  cartId: model.cartId,
                                  title: model.title,
                                  quantity: model.quantity,
                                  imageUrl: model.imageUrl,
                                  productId: model.productId,
                                ));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: defaultColor),
                          ),
                          color: defaultColor,
                          child: Text(
                            StoreAppCubit.get(context)
                                .orders.any((element) => element.productId==model.productId)
                                ? 'تم تأكيد الطلب'
                                : 'تأكيد الطلب',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Container(
                        width: 79.w,
                        height:6.h,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Icon(FontAwesome.whatsapp,color: Colors.green[700],size: 10.w,),
                                onTap: ()=>StoreAppCubit.get(context).openWattsAppChat(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: RaisedButton(
                                  onPressed: () {
                                    launch("tel:01093717500");
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color:defaultColor,
                                    ),
                                  ),
                                  color: defaultColor,
                                  child: Text(
                                    'الاتصال للطلب',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).textSelectionColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(
                left: 10, bottom: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          Positioned(
            child: Container(
              height: 10.w,
              width: 10.w,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.w)),
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                color: Colors.white,
                child: CircleAvatar(
                  radius: 10.0.w,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    size: 7.0.w,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  showDialogg(context, 'حذف المنتج من العربه',
                      'هل تريد حقل حذف المنتج من العربه', () {
                        StoreAppCubit.get(context).removeFromCart(model.cartId);
                      });
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
/*
Widget bottomSheet(context) => Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 05.0, left: 25, top: 10),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${StoreAppCubit.get(context).totalAmount.toStringAsFixed(0)}ج.م',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '  : المجموع',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: RaisedButton(
                    onPressed: ()  {
                      navigateTo(context, OrderDetailsScreen());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.redAccent),
                    ),
                    color: Colors.redAccent,
                    child: Text(
                      'اتمام الطلب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
*/
