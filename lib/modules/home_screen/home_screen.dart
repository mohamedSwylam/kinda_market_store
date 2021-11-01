import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/modules/product_screen/product_details.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        return Scaffold(
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
                      "الرئيسية",
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
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.grey[300],
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20),
                        child: Container(
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            onTap: () {},
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "ابحث في المتجر",
                              fillColor: Colors.white,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Feather.search),
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
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 160.0,
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
                            images: [
                              Image.asset(
                                'assets/images/banner1.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/banner2.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/banner3.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/bkala.jpg',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          'جميع الاصناف',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 150,
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
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          ' اشهر المنتجات ',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 370,
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
                  decoration: BoxDecoration(
                  ),
                  child: Stack(
                    children: [
                      Image(
                        image: NetworkImage(model.imageUrl),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        right:0,
                        bottom: 32.0,
                        child: Container(
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
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
                    SizedBox(height: 10,),
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
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
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
                            productId:  model.id,
                            title:  StoreAppCubit.get(context).findById(model.id).title,
                            price:  StoreAppCubit.get(context).findById(model.id).price,
                            imageUrl: StoreAppCubit.get(context).findById(model.id).imageUrl);
                      },
                      child: Icon(StoreAppCubit.get(context)
                          .carts.any((element) => element.productId== model.id)? MaterialCommunityIcons.check_all : Feather.shopping_cart,),
                    ),
                    GestureDetector(
                      child: Icon(
                        StoreAppCubit.get(context)
                            .wishList.any((element) => element.productId==model.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: StoreAppCubit.get(context)
                            .wishList.any((element) => element.productId==model.id)
                            ? Colors.red
                            : Theme.of(context).textSelectionColor,
                      ),
                      onTap:
                        StoreAppCubit.get(context)
                            .wishList.any((element) => element.productId==model.id)? (){}:() {
                          StoreAppCubit.get(context)
                              .addToWishList(
                            productId: model.id,
                            title:  model.title,
                            price: model.price,
                            imageUrl:  model.imageUrl ,
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
