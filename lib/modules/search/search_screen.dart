import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:badges/badges.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';

import '../feeds_screen/feeds_dialog.dart';



class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchTextController;
  final FocusNode _node = FocusNode();
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _searchTextController.dispose();
  }
  List<Product> _searchList = [];
  List<Product> searchQuery(String searchText) {
    List _searchList = StoreAppCubit.get(context).products
        .where((element) =>
        element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
  @override
  Widget build(BuildContext context) {
    final productsList = StoreAppCubit().products;
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
                  position: cubit.isEn ?BadgePosition.topEnd(top: -10, end: 28):BadgePosition.topEnd(top: -6, end: -5),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10),
              child: Text(
                cubit.getTexts('search1'),

                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * .09,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    onTap: () {},
                    controller: _searchTextController,
                    minLines: 1,
                    focusNode: _node,
                    cursorHeight: 20,
                    onChanged: (String enteredKeyword) {
                      List<Product> result = [];
                      if (enteredKeyword.isEmpty) {
                        // if the search field is empty or only contains white-space, we'll display all products
                        result = StoreAppCubit.get(context).products;
                      } else {
                        result = StoreAppCubit.get(context).products .where((element) =>
                            element.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
                            .toList();
                        // we use the toLowerCase() method to make it case-insensitive
                      }
                      // Refresh the UI
                      setState(() {
                        _searchList = result;
                      });
                    },
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    decoration: InputDecoration(
                      hintText:  '${cubit.getTexts('search2')}',
                      hintStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor,fontSize: 11.sp),
                      fillColor: Colors.white,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Feather.search,color:  Theme.of(context).scaffoldBackgroundColor,size: 8.w,),
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap:_searchTextController.text.isEmpty
                            ? null
                            : () {
                          _searchTextController.clear();
                          _node.unfocus();
                        },
                        child: Icon(Feather.x,
                              size: 8.w,
                              color: _searchTextController.text.isNotEmpty
                                  ? Colors.red
                                  : Colors.grey),
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
              Container(
                child: _searchTextController.text.isNotEmpty && _searchList.isEmpty
                    ? Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Icon(
                      Feather.search,
                      size: 60.sp,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      cubit.getTexts('search3'),
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                )
                    : GridView.count(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 240 / 420,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: List.generate(
                      _searchTextController.text.isEmpty
                          ? productsList.length
                          : _searchList.length, (index) {
                    return buildSearchItem(context, _searchList[index]);
                  }),
                ),
              ),
            ],
          ),

        ),
      ),
    );

  }

  Widget buildSearchItem(context, Product model) {
    var cubit = StoreAppCubit.get(context);
    return  Directionality(
      textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
      child: InkWell(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                FeedsDialog(
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

                child: Image(

                  fit: BoxFit.fill,

                  height: 180,

                  image: NetworkImage(model.imageUrl),

                  width: double.infinity,

                ),

              ),
              Container(
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        model.title, style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cubit.getTexts('cart2'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${model.price}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
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
                height:  8.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        StoreAppCubit.get(context).addItemToCart(
                            productId: model.id,
                            title: StoreAppCubit
                                .get(context)
                                .findById(model.id)
                                .title,
                            price: StoreAppCubit
                                .get(context)
                                .findById(model.id)
                                .price,
                            imageUrl: StoreAppCubit
                                .get(context)
                                .findById(model.id)
                                .imageUrl);
                      },
                      child: Icon(StoreAppCubit
                          .get(context)
                          .carts
                          .any((element) => element.productId == model.id)
                          ? MaterialCommunityIcons.check_all
                          : Feather.shopping_cart,size: 8.w,),
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

}