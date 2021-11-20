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
                      leading: Text(''),
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
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
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
                                itemCount: StoreAppCubit.get(context).carts.length,
                              ),
                            ),
                            SizedBox(height: 10.h,)
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
  var cubit = StoreAppCubit.get(context);
  return Container(
    height: 10.h,
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
                    '${StoreAppCubit.get(context).totalAmount.toStringAsFixed(0)}  ${cubit.getTexts('cart2')}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
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
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.06,
                child: RaisedButton(
                  onPressed: () {
                  navigateTo(
                        context,
                        OrderDetailsScreen());
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
      ],
    ),
  );
}

Widget buildCartItem(CartModel model, context) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false ? TextDirection.ltr : TextDirection.rtl,
    child: InkWell(
      onTap: () {
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
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          height: 43.h,
          width: 80.w,
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.only(
                                top: 0.0, right: 0, left: 0),
                            child: Container(
                              height: 22.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    .copyWith(
                                        color: Colors.black, fontSize: 18.sp),
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
                                  price: model.price,
                                  title: model.title,
                                  productId: model.productId,
                                  quantity: (model.quantity + 1),
                                  userId: model.userId,
                                  cartId: model.cartId,
                                );
                              },
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Text(
                              cubit.getTexts('cart5'),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Container(
                            width: 80.w,
                            height: 6.h,
                            child: RaisedButton(
                              onPressed: StoreAppCubit.get(context).orders.any(
                                      (element) =>
                                          element.productId == model.productId)
                                  ? () {}
                                  : () {
                                      navigateTo(
                                          context,
                                          OrderDetailsScreen(
                                            price: model.price,
                                            cartId: model.cartId,
                                            title: model.title,
                                            titleEn: model.titleEn,
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
                                StoreAppCubit.get(context).orders.any(
                                        (element) =>
                                            element.productId ==
                                            model.productId)
                                    ? cubit.getTexts('cart6')
                                    : cubit.getTexts('cart7'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).textSelectionColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            width: 79.w,
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
                                        cubit.getTexts('cart8'),
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
                          SizedBox(
                            height: 2.5.h,
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
                margin: const EdgeInsets.only(
                    left: 10, bottom: 10, right: 0, top: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16),),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              Positioned(
                top: 0,
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
                      showDialogg(context, cubit.getTexts('cart9'),
                          cubit.getTexts('cart10'), () {
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
    ),
  );
}
