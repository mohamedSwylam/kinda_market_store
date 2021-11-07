import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/category_model.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/modules/categories_screen/categoties_feed_screen.dart';
import 'package:kinda_store/modules/product_screen/product_details.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';
import 'package:sizer/sizer.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        var cubit=StoreAppCubit.get(context);
        return Scaffold(
          body: Center(
            child: BackdropScaffold(
              headerHeight: 3.h,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  height * .09,
                ),
                child: BackdropAppBar(
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
                        "الرئيسية",
                        style:   Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              backLayer: BackLayer(),
              frontLayer: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,vertical: 20.0,
                  ),
                  child: Center(
                    child: Container(
                      height: height * .09,
                      width: width*.70,
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.end,
                          onTap: () {
                            StoreAppCubit.get(context).selectedSearch();
                          },
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            hintText: "ابحث في المتجر",
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor),
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Feather.search,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: height * .2,
                      width: width*.88,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Carousel(
                          boxFit: BoxFit.fill,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 5.0,
                          dotIncreasedColor: defaultColor,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 0.0,
                          showIndicator: true,
                          borderRadius: true,
                          radius: Radius.circular(20),
                          indicatorBgPadding: 7.0,
                          images:
                          (StoreAppCubit.get(context).banners.length <
                              4)
                          ? [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/banners%2Fbkala.jpg?alt=media&token=ef69d9d8-7453-4bb3-933e-8e73102c6a1d',
                            fit: BoxFit.fill,
                          )
                          ]
                              : [
                      Image.network(
                      StoreAppCubit.get(context)
                          .banners[0]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[1]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[2]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[3]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,vertical: 20,
                ),
                child: Text(
                  'جميع الاصناف',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(
                      fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .25,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).categories;
                    return buildCategoryItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10.sp,
                  ),
                  itemCount:
                  StoreAppCubit.get(context).categories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,vertical: 20,
              ),
              child: Text(
                ' اشهر المنتجات ',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .6,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).products;
                    return buildProductItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            ],
          ),
        ),
        ),
        ),
        ),
        );
      },
    );
  }
}
Widget buildProductItem(context, Product model) => InkWell(
  onTap: () {
    navigateTo(context, ProductDetailsScreen(productId: model.id));
  },
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: LayoutBuilder(builder: (context, constraints) {
      double localHeight = constraints.maxHeight;
      double localwidth = constraints.maxWidth;
      return Container(
        width: 60.w,
        height: localHeight,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: localHeight*.65,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(model.imageUrl),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 32.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width*.30,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.black.withOpacity(0.7),
                      child: Row(
                        children: [
                          Text(
                            'ج.م',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${model.price}',
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: localwidth,
              height: 15.h,
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
                        fontSize: 15.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: localwidth,
                      child: Text(
                        model.description,
                        style: TextStyle(color: Colors.grey, fontSize: 5.sp),
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                ),
                width: double.infinity,
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
                        StoreAppCubit.get(context).carts.any(
                                (element) => element.productId == model.id)
                            ? MaterialCommunityIcons.check_all
                            : Feather.shopping_cart,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        StoreAppCubit.get(context).wishList.any(
                                (element) => element.productId == model.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: StoreAppCubit.get(context).wishList.any(
                                (element) => element.productId == model.id)
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
            ),
          ],
        ),
      );
    }),
  ),
);
Widget buildCategoryItem(context, CategoryModel category) => InkWell(
      onTap: () {
        navigateTo(
            context,
            CategoriesFeedScreen(
              categoryName: category.categoryName,
            ));
      },
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double localHeight = constraints.maxHeight;
            double localwidth = constraints.maxWidth;
            return Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .4,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff37475A).withOpacity(0.2),
                    blurRadius: 20.0,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Image(
                    image: AssetImage(
                      category.categoryImage,
                    ),
                    fit: BoxFit.fill,
                    height: localHeight,
                    width: localwidth,
                  ),
                  Container(
                      height: localHeight * .2,
                      width: localwidth,
                      color: Colors.black.withOpacity(0.8),
                      child: Center(
                        child: Text(
                          category.categoryName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            );
          }),
    );





/*

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileWidget: MobileContent(),
      tabletWidget: TabletContent(),
      webWidget: WebContent(),
    );
  }
}
Widget buildProductItem(context, Product model) => InkWell(
  onTap: () {
    navigateTo(context, ProductDetailsScreen(productId: model.id));
  },
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: LayoutBuilder(builder: (context, constraints) {
      double localHeight = constraints.maxHeight;
      double localwidth = constraints.maxWidth;
      return Container(
        width: MediaQuery.of(context).size.width*.70,
        height: localHeight,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: localHeight*.65,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(model.imageUrl),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 32.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width*.25,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.black.withOpacity(0.7),
                      child: Row(
                        children: [
                          Text(
                            'ج.م',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${model.price}',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: localwidth,
              height: localHeight* .25,
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                ),
                width: double.infinity,
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
                        StoreAppCubit.get(context).carts.any(
                                (element) => element.productId == model.id)
                            ? MaterialCommunityIcons.check_all
                            : Feather.shopping_cart,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        StoreAppCubit.get(context).wishList.any(
                                (element) => element.productId == model.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: StoreAppCubit.get(context).wishList.any(
                                (element) => element.productId == model.id)
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
            ),
          ],
        ),
      );
    }),
  ),
);
class MobileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        var cubit=StoreAppCubit.get(context);
        return Scaffold(
          body: Center(
            child: BackdropScaffold(
              headerHeight: width * .8,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  height * .09,
                ),
                child: BackdropAppBar(
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
                        "الرئيسية",
                        style:   Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    ),
                  ],
                ),
              ),
              backLayer: BackLayer(),
              frontLayer: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,vertical: 20.0,
                  ),
                  child: Center(
                    child: Container(
                      height: height * .09,
                      width: width*.70,
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.end,
                          onTap: () {
                            StoreAppCubit.get(context).selectedSearch();
                          },
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            hintText: "ابحث في المتجر",
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor),
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Feather.search,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: height * .2,
                      width: width*.88,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Carousel(
                          boxFit: BoxFit.fill,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 5.0,
                          dotIncreasedColor: defaultColor,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 0.0,
                          showIndicator: true,
                          borderRadius: true,
                          radius: Radius.circular(20),
                          indicatorBgPadding: 7.0,
                          images:
                          (StoreAppCubit.get(context).banners.length <
                              4)
                          ? [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/banners%2Fbkala.jpg?alt=media&token=ef69d9d8-7453-4bb3-933e-8e73102c6a1d',
                            fit: BoxFit.fill,
                          )
                          ]
                              : [
                      Image.network(
                      StoreAppCubit.get(context)
                          .banners[0]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[1]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[2]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[3]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,vertical: 20,
                ),
                child: Text(
                  'جميع الاصناف',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .25,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).categories;
                    return StoreAppCubit.get(context)
                        .buildCategoryItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                  itemCount:
                  StoreAppCubit.get(context).categories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,vertical: 20,
              ),
              child: Text(
                ' اشهر المنتجات ',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .6,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).products;
                    return buildProductItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            ],
          ),
        ),
        ),
        ),
        ),
        );
      },
    );
  }
}
class TabletContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        var cubit=StoreAppCubit.get(context);
        return Scaffold(
          body: Center(
            child: BackdropScaffold(
              headerHeight: width * .5,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  height * .1,
                ),
                child: BackdropAppBar(
                  leading: BackdropToggleButton(
                    icon: AnimatedIcons.home_menu,
                    color: Theme.of(context).splashColor,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 48.0,right: 60),
                        child: Badge(
                          badgeColor: defaultColor,
                          animationType: BadgeAnimationType.slide,
                          toAnimate: true,
                          position: BadgePosition.topEnd(top: -26, end: -25),
                          badgeContent: Text(
                            StoreAppCubit.get(context).carts.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 38),
                          ),
                          child: IconButton(
                            onPressed: () {
                              StoreAppCubit.get(context).selectedCart();
                            },
                            icon: Icon(
                              Feather.shopping_cart,
                              size: 40,
                              color: Theme.of(context).splashColor,
                            ),
                          ),
                        ),
                      ),
                      Badge(
                        badgeColor: defaultColor,
                        animationType: BadgeAnimationType.slide,
                        toAnimate: true,
                        position: BadgePosition.topEnd(top: -30, end: -28),
                        badgeContent: Text(
                          StoreAppCubit.get(context).wishList.length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        ),
                        child: IconButton(
                          onPressed: () {
                            navigateTo(context, WishListScreen());
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            size: 50,
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
                        "الرئيسية",
                        style:   Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 9.sp),
                      ),
                    ),
                  ],
                ),
              ),
              backLayer: BackLayer(),
              frontLayer: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,vertical: 20.0,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: height * .1,
                        width: width*.70,
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            onTap: () {
                              StoreAppCubit.get(context).selectedSearch();
                            },
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "ابحث في المتجر",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              fillColor: Colors.white,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Feather.search,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30,),
                    child: Container(
                      height: height * .27,
                      width: width*.88,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Carousel(
                          boxFit: BoxFit.fill,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 5.0,
                          dotIncreasedColor: defaultColor,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 0.0,
                          showIndicator: true,
                          borderRadius: true,
                          radius: Radius.circular(20),
                          indicatorBgPadding: 7.0,
                          images:
                          (StoreAppCubit.get(context).banners.length <
                              4)
                          ? [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/banners%2Fbkala.jpg?alt=media&token=ef69d9d8-7453-4bb3-933e-8e73102c6a1d',
                            fit: BoxFit.fill,
                          )
                          ]
                              : [
                      Image.network(
                      StoreAppCubit.get(context)
                          .banners[0]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[1]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[2]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[3]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,vertical: 20,
                  ),
                  child: Text(
                    'جميع الاصناف',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(
                      fontWeight: FontWeight.bold,fontSize: 40,),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .25,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).categories;
                    return StoreAppCubit.get(context)
                        .buildCategoryItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 50,
                  ),
                  itemCount:
                  StoreAppCubit.get(context).categories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 30,),
              child: Text(
                ' اشهر المنتجات ',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .6,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).products;
                    return buildProductItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            ],
          ),
        ),
        ),
        ),
        ),
        );
      },
    );
  }
}
class WebContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        var cubit=StoreAppCubit.get(context);
        return Scaffold(
          body: Center(
            child: BackdropScaffold(
              headerHeight: width * .8,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  height * .09,
                ),
                child: BackdropAppBar(
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
                        "الرئيسية",
                        style:   Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              backLayer: BackLayer(),
              frontLayer: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,vertical: 20.0,
                  ),
                  child: Center(
                    child: Container(
                      height: height * .09,
                      width: width*.70,
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.end,
                          onTap: () {
                            StoreAppCubit.get(context).selectedSearch();
                          },
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            hintText: "ابحث في المتجر",
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor),
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Feather.search,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: height * .2,
                      width: width*.88,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Carousel(
                          boxFit: BoxFit.fill,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 5.0,
                          dotIncreasedColor: defaultColor,
                          dotPosition: DotPosition.bottomCenter,
                          dotVerticalPadding: 0.0,
                          showIndicator: true,
                          borderRadius: true,
                          radius: Radius.circular(20),
                          indicatorBgPadding: 7.0,
                          images:
                          (StoreAppCubit.get(context).banners.length <
                              4)
                          ? [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-app3-17a99.appspot.com/o/banners%2Fbkala.jpg?alt=media&token=ef69d9d8-7453-4bb3-933e-8e73102c6a1d',
                            fit: BoxFit.fill,
                          )
                          ]
                              : [
                      Image.network(
                      StoreAppCubit.get(context)
                          .banners[0]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[1]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[2]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[3]
                          .imageUrl,
                      fit: BoxFit.fill,
                    ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,vertical: 20,
                ),
                child: Text(
                  'جميع الاصناف',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .25,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).categories;
                    return StoreAppCubit.get(context)
                        .buildCategoryItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                  itemCount:
                  StoreAppCubit.get(context).categories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,vertical: 20,
              ),
              child: Text(
                ' اشهر المنتجات ',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: height * .6,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).products;
                    return buildProductItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            ],
          ),
        ),
        ),
        ),
        ),
        );
      },
    );
  }
}

*/
