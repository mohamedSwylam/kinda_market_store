import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/cart_model.dart';
import 'package:kinda_store/modules/order_screen/order_details.dart';
import 'package:kinda_store/modules/product_screen/product_details.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart';

import 'empty_cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = StoreAppCubit.get(context);
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return StoreAppCubit.get(context).carts.isEmpty
              ? Scaffold(
                  body: EmptyCart(),
                )
              : Directionality(
                  textDirection: cubit.isEn == false
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          showDialogg(context, cubit.getTexts('cart12'),
                              cubit.getTexts('cart11'), () {
                                StoreAppCubit.get(context).clearCart();
                              });
                        },
                        icon: Icon(
                          Feather.trash,
                          size: 25,
                          color: Theme.of(context).splashColor,
                        ),
                      ),
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
                            "${cubit.getTexts('cart1')} (${StoreAppCubit.get(context).carts.length})",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    body: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var list = StoreAppCubit.get(context).carts;
                                  return buildCartItem(list[index], context);
                                },
                                separatorBuilder: (context, index) => Container(
                                  height: 4.w,
                                ),
                                itemCount:
                                    StoreAppCubit.get(context).carts.length,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        ),
                      ),
                    ),
                    bottomSheet: bottomSheet(context),
                  ),
                );
        });
  }
}

Widget bottomSheet(context) {
  double totalAmount = StoreAppCubit.get(context).totalAmount;
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false
        ? TextDirection.ltr
        : TextDirection.rtl,
    child: Container(
      height: 10.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '${cubit.getTexts('cart2')}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 1.w,),
                    Text(
                      '${StoreAppCubit.get(context).totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  cubit.getTexts('orderDetails4'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: defaultColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.06,
              child: RaisedButton(
                onPressed: () {
                  navigateTo(context, OrderDetailsScreen(totalAmount:totalAmount,));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: defaultColor),
                ),
                color: defaultColor,
                child: Text(
                  cubit.getTexts('cart7'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget buildCartItem(CartModel model,context){
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false
        ? TextDirection.ltr
        : TextDirection.rtl,
    child: InkWell(
      onTap: (){
        StoreAppCubit.get(context).addToWatchedProduct(
            productId: model.productId,
            title: StoreAppCubit.get(context).findById(model.productId).title,
            price: StoreAppCubit.get(context).findById(model.productId).price,
            descriptionEn: StoreAppCubit.get(context)
                .findById(model.productId)
                .descriptionEn,
            titleEn:
            StoreAppCubit.get(context).findById(model.productId).titleEn,
            description: StoreAppCubit.get(context)
                .findById(model.productId)
                .description,
            imageUrl:
            StoreAppCubit.get(context).findById(model.productId).imageUrl);
        navigateTo(
            context,
            ProductDetailsScreen(
              productId: model.productId,
            ));
        },
      child: Container(
        height: 25.h,
        child:  Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialogg(context, cubit.getTexts('cart9'),
                              cubit.getTexts('cart10'), () {
                                StoreAppCubit.get(context)
                                    .removeFromCart(model.cartId);
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Icon(
                            Icons.close,
                            size: 6.0.w,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Container(
                        width: 40.w,
                        child: Text(
                          '${cubit.isEn ? model.titleEn : model.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                              fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cubit.getTexts('cart2'),
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
                        cubit.getTexts('cart3'),
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cubit.getTexts('cart2'),
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '${(model.price * model.quantity).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        cubit.getTexts('cart4'),
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          child: CircleAvatar(
                            radius: 4.5.w,
                            backgroundColor: defaultColor,
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 2.5.w,
                                backgroundColor: defaultColor,
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Colors.black,
                                  size: 4.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (model.quantity > 0) {
                            StoreAppCubit.get(context).reduceItemByOne(
                              imageUrl: model.imageUrl,
                              price: model.price,
                              title: model.title,
                              productId: model.productId,
                              quantity: (model.quantity - 1),
                              userId: model.userId,
                              cartId: model.cartId,
                            );
                          }
                        },
                      ),
                      Container(
                        child: Center(
                            child: Text(
                              '${model.quantity.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                  color: Colors.black, fontSize: 15.sp),
                            )),
                      ),
                      InkWell(
                        child: Container(
                          child: CircleAvatar(
                            radius: 4.5.w,
                            backgroundColor: defaultColor,
                            child: CircleAvatar(
                              radius: 3.w,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 2.5.w,
                                backgroundColor: defaultColor,
                                child: Icon(
                                  Icons.arrow_upward_outlined,
                                  color: Colors.black,
                                  size: 4.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          StoreAppCubit.get(context).addItemByOne(
                            imageUrl: model.imageUrl,
                            price: model.price,
                            title: model.title,
                            productId: model.productId,
                            quantity: (model.quantity + 1),
                            userId: model.userId,
                            cartId: model.cartId,
                          );
                        },
                      ),
                      Text(
                        cubit.getTexts('cart5'),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11.0.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            Image.network(model.imageUrl,
              width: 35.w,
              height: 27.h,
              fit: BoxFit.fill,
              errorBuilder:(context,child,progress){
                return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
              },
              loadingBuilder:(context,child,progress){
                return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
              },
                ),
          ],
        ),
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16.0),
            topLeft: const Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
    ),
  );
}

