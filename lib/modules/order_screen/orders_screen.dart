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
import 'package:kinda_store/models/order_model.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';

import 'empty_order.dart';
class OrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return  StoreAppCubit.get(context).orders.isEmpty
              ? Scaffold(
            body: EmptyOrder(),
          )
              :Scaffold(
            body: Center(
              child: BackdropScaffold(
                headerHeight: MediaQuery.of(context).size.height * .25,
                appBar: BackdropAppBar(
                  leading: BackdropToggleButton(
                    icon: AnimatedIcons.home_menu,
                    color: Theme.of(context).splashColor,
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
                          position: BadgePosition.topEnd(top: -6, end: -5),
                          badgeContent: Text(StoreAppCubit
                              .get(context)
                              .carts
                              .length
                              .toString(),
                            style: TextStyle(color: Colors.white, fontSize: 18),),
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
                      SizedBox(width: 5,),
                      Badge(
                        badgeColor: defaultColor,
                        animationType: BadgeAnimationType.slide,
                        toAnimate: true,
                        position: BadgePosition.topEnd(top: -5, end: -3),
                        badgeContent: Text(StoreAppCubit
                            .get(context)
                            .wishList
                            .length
                            .toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18),),
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
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        'الطلبات (${StoreAppCubit.get(context).orders.length})',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                    ),
                  ],
                ),
                backLayer: BackLayer(),
                frontLayer: Scaffold(
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
              ),
            ),
          );

        });
  }
}

Widget buildOrderItem(context ,OrderModel orderModel) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10.0),
  child: Container(
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${orderModel.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 20),
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
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${orderModel.total}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '  : الاجمالي ',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '....جاري توصيل الطلب',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 120,
              height: 145,
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
);
