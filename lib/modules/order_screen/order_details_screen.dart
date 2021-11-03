import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/shared/styles/color.dart';

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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation:1,
            actions: [
              Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 11),
                child: Text(
                  'تفاصيل الطلب',
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
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          'تفاصيل التواصل',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                height: 5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${StoreAppCubit.get(context).name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 15),
                              ),
                              SizedBox(
                                height: 7,
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
                                        .copyWith(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${StoreAppCubit.get(context).phone}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 15,
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
                  SizedBox(height: 20,),
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
                                          'ج.م',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${productAttr.price.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      'السعر',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                                          width: 46,
                                        ),
                                        Text(
                                          '${quantity}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      'الكميه',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                                          'ج.م',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${(price*quantity).toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      'الاجمالي',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
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
                                          'ج.م',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '10',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      'الشحن',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
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
                                          'ج.م',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${total.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      ' السعر الكلي ',
                                      style: TextStyle(
                                        fontSize: 16.0,
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
                            ],
                          ),
                        ),
                      ),
                      myDivider(),
                    ],
                  ),
                  SizedBox(height: 20,),
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
                              defaultFormField(
                                  type: TextInputType.text,
                                  controller: addressDetailsController,
                                  onSubmit: () {},
                                  prefix: Icons.location_on,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'العنوان الذي ادخلته غير صالح';
                                    }
                                    return null;
                                  },
                                  context: context,
                                  labelText: 'تفاصيل اكثر عن العنوان '
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  type: TextInputType.phone,
                                  controller: anotherPhoneController,
                                  onSubmit: () {},
                                  prefix: Icons.call,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'رثم الهاتف الذي ادخلته غير صالح';
                                    }
                                    return null;
                                  },
                                  context: context,
                                  labelText: 'رقم هاتف اخر للتواصل'
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
                  SizedBox(height: 20,),
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
                            ? 'الاستفسار بشأن الطلب'
                            : 'الاتصال للطلب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
