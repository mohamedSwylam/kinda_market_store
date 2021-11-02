
import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
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
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';

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
              :Scaffold(
            body: Center(
              child: BackdropScaffold(
                headerHeight: MediaQuery.of(context).size.height * .25,
                appBar: BackdropAppBar(
                  leading: BackdropToggleButton(
                    icon: AnimatedIcons.home_menu,
                    color: Colors.black,
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.grey[300],
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Text(
                        "العربه (${StoreAppCubit.get(context).carts.length})",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                backLayer: BackLayer(),
                frontLayer: Scaffold(
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
                          height: 8,
                        ),
                        itemCount: StoreAppCubit.get(context).carts.length,
                      ),
                    ),
                  ),
                  // bottomSheet: bottomSheet(context),
                ),
              ),
            ),
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
                          height: 18,
                        ),
                        Text(
                          '${model.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 15),
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
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${model.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '  :  السعر',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
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
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${(model.price*model.quantity).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '  : السعر الكلي ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,right: 10),
                    child: Container(
                      width: 120,
                      height: 120,
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
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0),
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 45,
                        child: CircleAvatar(
                          backgroundColor: defaultColor,
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.black,
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
                    Container(
                      height: 40,
                      width: 65,
                      child: Center(
                          child: Text(
                            '${model.quantity.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black),
                          )),

                    ),
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 45,
                        child: CircleAvatar(
                          backgroundColor: defaultColor,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.black,
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
                    Spacer(),
                    Text(
                      '  : الكميه ',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
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
              SizedBox(height: 15,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      child: Icon(FontAwesome.whatsapp,color: Colors.green[700],size: 38,),
                      onTap: () {  },
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 235,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: RaisedButton(
                      onPressed: () {
                        launch("tel:01098570050");
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
                ],
              ),
              SizedBox(height: 15,),
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
            height: 30,
            width: 30,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              color: Colors.redAccent,
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 20.0,
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
