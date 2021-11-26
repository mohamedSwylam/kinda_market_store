import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/category_model.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/models/watched_product_model.dart';
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
        return Directionality(
          textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
          child: Scaffold(
          body: Center(
            child: BackdropScaffold(
              headerHeight: 6.h,
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
                  elevation: 0.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Text(
                        cubit.getTexts('home1'),
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
                            hintText:cubit.getTexts('home2'),
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
                            errorBuilder:(context,child,progress){
                              return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                            },
                            loadingBuilder:(context,child,progress){
                              return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                            },
                          )
                          ]
                              : [
                      Image.network(
                      StoreAppCubit.get(context)
                          .banners[0]
                          .imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                      loadingBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[1]
                          .imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                      loadingBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[2]
                          .imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                      loadingBuilder:(context,child,progress){
                        return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                      },
                    ),
                    Image.network(
                      StoreAppCubit.get(context)
                          .banners[3]
                          .imageUrl,
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
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,vertical: 20,
                ),
                child: Text(
                  cubit.getTexts('home3'),
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
                    return StoreAppCubit.get(context).isEn==false?buildCategoryItem(context, list[index]):buildCategoryItem(context, StoreAppCubit.get(context).categoriesEng[index]);
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
                cubit.getTexts('home4'),
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 65.5.h,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var list = StoreAppCubit.get(context).products;
                    return buildProductItem(context, list[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: StoreAppCubit.get(context).products.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,vertical: 20,
              ),
              child: Text(
                cubit.getTexts('home16'),
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
            ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var list=StoreAppCubit.get(context).watchedProducts;
                          return buildWatchedRecentlyItem(context,list[index]);
                        },
                        separatorBuilder: (context, index) => Container(
                          height: 2.h,
                        ),
                        itemCount: StoreAppCubit.get(context).watchedProducts.length,
                      ),
            SizedBox(height: 20.h,)
            ],
          ),
        ),
        ),
        ),
        ),
        ));
      },
    );
  }
}
Widget buildProductItem(context, Product model) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
    child: InkWell(
      onTap: () {
        StoreAppCubit.get(context).addToWatchedProduct(
            productId: model.id,
            title: StoreAppCubit.get(context)
                .findById(model.id)
                .title,
            price: StoreAppCubit.get(context)
                .findById(model.id)
                .price,
            descriptionEn:StoreAppCubit.get(context)
                .findById(model.id)
                .descriptionEn,
            titleEn:StoreAppCubit.get(context)
                .findById(model.id)
                .titleEn,
            description: StoreAppCubit.get(context)
                .findById(model.id)
                .description,
            imageUrl: StoreAppCubit.get(context)
                .findById(model.id)
                .imageUrl);
        navigateTo(context, ProductDetailsScreen(productId: model.id));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: LayoutBuilder(builder: (context, constraints) {
          double localHeight = constraints.maxHeight;
          double localwidth = constraints.maxWidth;
          return Container(
            width: 60.w,
            height: 60.h,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Image.network(
                         model.imageUrl,
                          errorBuilder:(context,child,progress){
                            return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                          },
                          loadingBuilder:(context,child,progress){
                            return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                          },
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
                                  cubit.getTexts('cart2'),
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
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: localwidth,
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
                            cubit.isEn?model.titleEn:model.title,
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
                              cubit.isEn? model.descriptionEn:model.description,
                              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
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
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //height: 8.h,
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
                                titleEn:StoreAppCubit.get(context)
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
                              titleEn: model.titleEn,
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
    ),
  );
}

Widget buildCategoryItem(context, CategoryModel category) => InkWell(
      onTap: () {
        navigateTo(
            context,
            CategoriesFeedScreen(
              categoryId: category.categoryId,
              categoryName: category.categoryName,
            ));
        print(StoreAppCubit.get(context).isEn);
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

Widget buildWatchedRecentlyItem(context,WatchedModel model) {
  var cubit = StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
    child: InkWell(
      onTap: (){
        navigateTo(context, ProductDetailsScreen(productId: model.productId));
      },
      child: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 6.w,
                                ),
                                onTap: (){
                                  StoreAppCubit.get(context).removeFromWatched(model.watchedId);
                                },
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 35.w,
                              child: Text(
                               '${cubit.isEn? model.titleEn:model.title}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 13.sp,color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              cubit.getTexts('cart2'),
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '${model.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          '${cubit.isEn? model.descriptionEn:model.description}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey,fontSize: 11.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: StoreAppCubit.get(context)
                            .carts
                            .any((element) =>
                        element.productId == model.productId)
                            ? () {}
                            : () {
                          StoreAppCubit.get(context)
                              .addItemToCart(
                              productId: model.productId,
                              title: model.title,
                              titleEn: model.titleEn,
                              price: model.price,
                              imageUrl: model.imageUrl);
                        },
                              child: Text(
                                StoreAppCubit.get(context).carts.any(
                                        (element) =>
                                    element.productId == model.productId)
                                    ?  '${cubit.getTexts('feedsDia3')}'
                                    :  '${cubit.getTexts('feedsDia4')}',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red,fontSize: 15.sp),
                              ),
                            ),
                            Icon(
                              Entypo.plus,
                              size: 6.w,
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.5.h,
                ),
                Container(
                  width: 35.w,
                  height: 27.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('${model.imageUrl}',)),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
              top: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(16.0),
                topLeft: const Radius.circular(16.0),
                bottomRight: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          Positioned(
            top: 25.h,
            left: 7,
            child: Container(
              height: 6.h,
              width: 10.w,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                color: Colors.white,
                child: CircleAvatar(
                  radius: 8.w,
                  backgroundColor: Colors.white,
                  child: Icon(
                    StoreAppCubit.get(context).wishList.any(
                            (element) => element.productId == model.productId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: StoreAppCubit.get(context).wishList.any(
                            (element) => element.productId == model.productId)
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
                onPressed: StoreAppCubit.get(context)
                    .wishList
                    .any((element) => element.productId == model.productId)
                    ? () {}
                    : () {
                  StoreAppCubit.get(context).addToWishList(
                    productId: model.productId,
                    title: model.title,
                    titleEn: model.titleEn,
                    price: model.price,
                    imageUrl: model.imageUrl,
                    userId: StoreAppCubit.get(context).uId,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}




