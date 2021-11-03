import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var productAttr = StoreAppCubit.get(context).findById(productId);
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Badge(
                badgeColor: defaultColor,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                position: BadgePosition.topEnd(top: 0,end: -8),
                badgeContent: Text(StoreAppCubit.get(context).carts.length.toString(),style: TextStyle(color: Colors.white,fontSize: 18),),
                child: IconButton(
                  onPressed: () {
                    navigateTo(context, CartScreen());
                  },
                  icon: Icon(
                    Feather.shopping_cart,
                    size: 25,
                    color: Theme.of(context).splashColor,
                  ),
                ),
              ),
            ),
            title: Badge(
              badgeColor: defaultColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: -5,end: -3),
              badgeContent: Text(StoreAppCubit.get(context).wishList.length.toString(),style: TextStyle(color: Colors.white,fontSize: 18),),
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
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                child: Text(
                  'تفاصيل المنتج',
                  style:  Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  color: Colors.black12,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.38,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(productAttr.imageUrl),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 240.0,
                    bottom: 0.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${productAttr.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 22),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'ج.م',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    '${productAttr.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                '${productAttr.description}',
                                maxLines: 15,
                                textAlign: TextAlign.end,
                                style:  Theme.of(context)
                                    .textTheme
                                    .bodyText2,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 10,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '0 %',
                                        style: Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 18),
                                      Text(
                                        '0 %',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '0 %',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 17),
                                      Text(
                                        '0 %',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '0 %',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: 160,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      Container(
                                        width: 160,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      SizedBox(height: 26),
                                      Container(
                                        width: 160,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      SizedBox(height: 28),
                                      Container(
                                        width: 160,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      Container(
                                        width: 160,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'رائع',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'ممتاز',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'جيد',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 17),
                                      Text(
                                        'لم يعجبني',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'سئ',
                                        style:  Theme.of(context).textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.vertical,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            myDivider(),
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: 85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'بدون تقييم حتي الان',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'كن اول من يقيم',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            myDivider(),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'قد يعجبك ايضا',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                height: 370,
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var list =
                                        StoreAppCubit.get(context).products;
                                    return buildSuggestProduct(
                                        context, list[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(),
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 50,
                                child: RaisedButton(
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(side: BorderSide.none),
                                  color: Colors.yellow[700],
                                  onPressed: StoreAppCubit.get(context).carts.any(
                                          (element) => element.productId == productId)
                                      ? () {}
                                      : () {
                                    StoreAppCubit.get(context).addItemToCart(
                                        productId: productId,
                                        title: productAttr.title,
                                        price: productAttr.price,
                                        imageUrl: productAttr.imageUrl);
                                  },
                                  child: Text(
                                    StoreAppCubit.get(context).carts.any(
                                            (element) => element.productId == productId)
                                        ? 'في العربه '.toUpperCase()
                                        : 'اضف الي العربه'.toUpperCase(),
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
                                child: RaisedButton(
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(side: BorderSide.none),
                                  color: Theme.of(context).backgroundColor,
                                  onPressed: () {
                                    StoreAppCubit.get(context).addItemToCart(
                                        productId: productId,
                                        title: productAttr.title,
                                        price: productAttr.price,
                                        imageUrl: productAttr.imageUrl);
                                    StoreAppCubit.get(context).selectedCart();
                                    navigateTo(context, StoreLayout());
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'اشتري الان'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                            Theme.of(context).textSelectionColor),
                                      ),
                                      SizedBox(
                                        width: 18,
                                      ),
                                      Icon(
                                        Icons.payment,
                                        color: Colors.green.shade700,
                                        size: 17,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: StoreAppCubit.get(context).isDark
                                    ? Theme.of(context).disabledColor
                                    : ColorsConsts.subTitle,
                                height: 50,
                                child: InkWell(
                                  splashColor: ColorsConsts.favColor,
                                  onTap: StoreAppCubit.get(context).wishList.any(
                                          (element) => element.productId == productId)
                                      ? () {}
                                      : () {
                                    StoreAppCubit.get(context).addToWishList(
                                      productId: productId,
                                      title: productAttr.title,
                                      price: productAttr.price,
                                      imageUrl: productAttr.imageUrl,
                                      userId: StoreAppCubit.get(context).uId,
                                    );
                                  },
                                  child: Center(
                                    child: Icon(
                                      StoreAppCubit.get(context).wishList.any(
                                              (element) =>
                                          element.productId == productId)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: StoreAppCubit.get(context).wishList.any(
                                              (element) =>
                                          element.productId == productId)
                                          ? Colors.redAccent
                                          : ColorsConsts.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildSuggestProduct(context, Product model) => InkWell(
      onTap: () {
        navigateTo(context, ProductDetailsScreen(productId: model.id));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: 220,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Image(
                        image: NetworkImage(model.imageUrl),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 90,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        model.title,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: 160,
                        child: Text(
                          model.description,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                height: 50,
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
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        StoreAppCubit.get(context)
                                .wishList
                                .any((element) => element.productId == model.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: StoreAppCubit.get(context)
                                .wishList
                                .any((element) => element.productId == model.id)
                            ? Colors.red
                            : Theme.of(context).textSelectionColor,
                      ),
                      onTap: StoreAppCubit.get(context)
                              .wishList
                              .any((element) => element.productId == model.id)
                          ? () {}
                          : () {
                              StoreAppCubit.get(context).addToWishList(
                                productId: model.id,
                                title: model.title,
                                price: model.price,
                                imageUrl: model.imageUrl,
                                userId: StoreAppCubit.get(context).uId,
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
