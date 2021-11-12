import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'order_confirm_dialog.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String productId;
  final String cartId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;
   OrderDetailsScreen(
      {
        @required this.productId,
        @required this.cartId,
        @required this.price,
        @required this.quantity,
        @required this.title,
        @required this.imageUrl});
  var uuid = Uuid();
  var formKey = GlobalKey<FormState>();
  var anotherPhoneController=TextEditingController();
  var addressDetailsController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var productAttr = StoreAppCubit.get(context).findById(productId);
        double total= ((price*quantity))+10;
        var cubit = StoreAppCubit.get(context);
        return Directionality(
            textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
            child: Scaffold(
            appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation:1,
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    child: IconButton(
                      onPressed: () {
                        StoreAppCubit.get(context).selectedCart();
                      },
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
                  position: StoreAppCubit.get(context).isEn ?BadgePosition.topEnd(top: -10, end: 28):BadgePosition.topEnd(top: -5, end: -3),
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
            actions: [
              Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 11),
                child: Text(
                  cubit.getTexts('orderDetails2'),
                  style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
              ),
          )],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          cubit.getTexts('orderDetails3'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 13.sp),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      myDivider(),
                        Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Text(
                                '${StoreAppCubit.get(context).name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 13.sp),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              if(StoreAppCubit.get(context).address !='')
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${StoreAppCubit.get(context).address}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontSize: 13.sp),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    '${StoreAppCubit.get(context).phone}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontSize: 13.sp),
                                  ),
                                  SizedBox(
                                    height: 2.5.h,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      myDivider(),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cubit.getTexts('cart2'),
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '${productAttr.price.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      cubit.getTexts('cart3'),
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 5.w
                                        ),
                                        Text(
                                          '${quantity}',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      cubit.getTexts('cart5'),
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cubit.getTexts('cart2'),
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '${(price*quantity).toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      cubit.getTexts('orderDetails4'),
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cubit.getTexts('cart2'),
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '10',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      cubit.getTexts('orderDetails5'),
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cubit.getTexts('cart2'),
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '${total.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      cubit.getTexts('cart4'),
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      myDivider(),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2.5.h,
                              ),
                              defaultFormFiled(
                                  type: TextInputType.text,
                                  controller: addressDetailsController,
                                  prefix: Icons.location_on,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return '${cubit.getTexts('orderDetails6')}';
                                    }
                                    return null;
                                  },
                                  hint: cubit.getTexts('orderDetails7'),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2.5.h,
                              ),
                              defaultFormFiled(
                                  type: TextInputType.phone,
                                  controller: anotherPhoneController,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return '${cubit.getTexts('orderDetails8')}';
                                    }
                                    return null;
                                  },
                                  hint: cubit.getTexts('orderDetails9'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      myDivider(),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: RaisedButton(
                      onPressed: () async {
                        final orderId=uuid.v4();
                        if (formKey.currentState.validate()) {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderId)
                              .set({
                            'orderId': orderId.toString(),
                            'productId': productId.toString(),
                            'userId': StoreAppCubit.get(context).uId.toString(),
                            'title': title,
                            'price': price,
                            'subTotal': (price*quantity),
                            'total':total,
                            'userPhone': StoreAppCubit
                                .get(context)
                                .phone,
                            'username': StoreAppCubit
                                .get(context)
                                .name,
                            'quantity': quantity,
                            'userAddress': StoreAppCubit
                                .get(context)
                                .address,
                            'addressDetails': addressDetailsController.text,
                            'anotherNumber': anotherPhoneController.text,
                            'imageUrl': imageUrl,
                          });
                          StoreAppCubit.get(context).getOrders();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => OrderConfirmDialog(),
                          );
                           StoreAppCubit.get(context).selectedHome();
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color:defaultColor),
                      ),
                      color: defaultColor,
                      child: Text(
                        StoreAppCubit.get(context)
                            .orders.any((element) => element.productId==productId)
                            ? '${cubit.getTexts('cart6')}'
                            : '${cubit.getTexts('cart7')}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: RaisedButton(
                      onPressed: () {
                        launch("tel:01098570050");
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: defaultColor),
                      ),
                      color: defaultColor,
                      child: Text(
                        StoreAppCubit.get(context)
                            .orders.any((element) => element.productId==productId)
                            ? '${cubit.getTexts('orderDetails10')}'
                            : '${cubit.getTexts('cart8')}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
