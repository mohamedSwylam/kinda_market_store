import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/cart_model.dart';
import 'package:kinda_store/modules/product_screen/product_details.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/components/constants.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'order_confirm_dialog.dart';

class OrdScreen extends StatelessWidget {
  final double totalAmount;
  var uuid = Uuid();
  var formKey = GlobalKey<FormState>();
  var anotherPhoneController=TextEditingController();
  var addressDetailsController=TextEditingController();
   OrdScreen({ this.totalAmount});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                          ),
                          Padding(
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
                                        .copyWith(fontSize: 13.sp,color: Colors.black),
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
                                              .copyWith(fontSize: 13.sp,color: Colors.black),
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
                                              .copyWith(fontSize: 13.sp,color: Colors.black),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          myDivider(),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var list = StoreAppCubit.get(context).carts;
                                  return buildCartItem(list[index], context);
                                },
                                itemCount: StoreAppCubit.get(context).carts.length,
                              ),
                            ),
                          ),
                          myDivider(),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
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
                                                fontSize: 15.0.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              '${totalAmount.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          cubit.getTexts('cart4'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize: 14.sp, color: Colors.black),
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
                                                fontSize: 15.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              '10',
                                              style: TextStyle(
                                                fontSize: 15.0.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          cubit.getTexts('orderDetails5'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize: 14.sp, color: Colors.black),
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
                                                fontSize: 15.0.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              '${(totalAmount+10).toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 15.0.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          cubit.getTexts('orderDetails4'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize: 14.sp, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          myDivider(),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
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
                            height: 2.h,
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
                        child: Column(
                          children: [
                            Container(
                              width: 90.w,
                              height: 6.h,
                              child: RaisedButton(
                                onPressed: () async {
                                  final orderId=uuid.v4();
                                  if (formKey.currentState.validate()) {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(orderId)
                                        .set({
                                      'orderId': orderId.toString(),
                                      'userId': StoreAppCubit.get(context).uId.toString(),
                                      'products': StoreAppCubit.get(context).carts.map((e) => e.title).toList(),
                                      'productsEn': StoreAppCubit.get(context).carts.map((e) => e.titleEn).toList(),
                                      'titleEn': StoreAppCubit.get(context).carts[1].titleEn,
                                      'title': StoreAppCubit.get(context).carts[1].title,
                                      'subTotal': totalAmount,
                                      'total': totalAmount+10,
                                      'userPhone': StoreAppCubit
                                          .get(context)
                                          .phone,
                                      'username': StoreAppCubit
                                          .get(context)
                                          .name,
                                      'userAddress': StoreAppCubit
                                          .get(context)
                                          .address,
                                      'addressDetails': addressDetailsController.text,
                                      'anotherNumber': anotherPhoneController.text,
                                      'imageUrl': StoreAppCubit.get(context).carts[1].imageUrl,
                                    });
                                    StoreAppCubit.get(context).getOrders();
                                   // StoreAppCubit.get(context).pushNotification(title:'اوردر جديد',body:' قام ${StoreAppCubit.get(context).name}   بطلب اوردر جديد  ',token: karima);
                                    StoreAppCubit.get(context).pushNotification(title:'اوردر جديد',body:' قام ${StoreAppCubit.get(context).name}   بطلب اوردر جديد  ',token: y9ksc);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => OrderConfirmDialog(),
                                    );
                                  }
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
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
                              height: 6.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
Widget buildCartItem(CartModel model, context) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false ? TextDirection.ltr : TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 25,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(model.price * model.quantity).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${model.quantity.toString()}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                            color: Colors.grey, fontSize: 13.sp),
                      ),
                      Text(
                        'x',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${model.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 35.w,
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
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}