import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';

import 'feeds_dialog.dart';

class FeedsScreen extends StatelessWidget {
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
                  position: cubit.isEn ?BadgePosition.topEnd(top: -10, end: 28):BadgePosition.topEnd(top: -5, end: -3),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Text(
                  cubit.getTexts('feeds'),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          body: Container(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: StoreAppCubit.get(context).products.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                var list = StoreAppCubit.get(context).products;
                return buildFeedsItem(context, list[index]);
              },
            ),
          ),
        ));
      },
    );
  }
}

Widget buildFeedsItem(context, Product model) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
    child: InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => FeedsDialog(
            productId: model.id,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xff37475A).withOpacity(0.2),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                model.imageUrl,
                fit: BoxFit.fill,
                height: 180,
                errorBuilder:(context,child,progress){
                  return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                },
                loadingBuilder:(context,child,progress){
                  return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                },
                width: double.infinity,
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      cubit.isEn?model.titleEn:model.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cubit.getTexts('cart2'),
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${model.price}',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: defaultColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
              ),
              width: double.infinity,
              height: 8.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      StoreAppCubit.get(context).addItemToCart(
                          productId: model.id,
                          title: StoreAppCubit.get(context)
                              .findById(model.id)
                              .title,
                          titleEn: StoreAppCubit.get(context)
                              .findById(model.id)
                              .titleEn,
                          price: StoreAppCubit.get(context)
                              .findById(model.id)
                              .price,
                          imageUrl: StoreAppCubit.get(context)
                              .findById(model.id)
                              .imageUrl);
                    },
                    child: Icon(
                      StoreAppCubit.get(context)
                          .carts
                          .any((element) => element.productId == model.id)
                          ? MaterialCommunityIcons.check_all
                          : Feather.shopping_cart,
                      size: 8.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
