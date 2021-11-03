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
import 'package:kinda_store/models/wishlist_model.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:kinda_store/widget/backlayer.dart';

import 'empty_wishlist.dart';

class WishListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return  StoreAppCubit.get(context).wishList.isEmpty
              ? Scaffold(
            body: EmptyWishList(),
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
                        "المفضله (${StoreAppCubit.get(context).wishList.length})",
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
                        var list=StoreAppCubit.get(context).wishList;
                        return buildWishListItem(list[index],context);
                      },
                      separatorBuilder: (context, index) => Container(
                        height: 8,
                      ),
                      itemCount: StoreAppCubit.get(context).wishList.length,
                    ),
                  ),
                )
              ),
            ),
          );
        });
  }
}

Widget buildWishListItem(WishListModel model,context)=>InkWell(
  onTap: (){
    //navigateTo(context, ProductDetailsScreen(productId: model.productId,));
  },
  child: Stack(
    children: [
      Container(
        height: 130,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${model.title}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${model.price}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 120,
              height: 165,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    '${model.imageUrl}',
                  ),
                ),
              ),
            ),],
        ),
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16.0),
            topLeft: const Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      Positioned(
        top: 20,
        left: 10,
        child: Container(
          height: 30,
          width: 30,
          child: MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              color: Colors.redAccent,
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed:(){
               showDialogg(context, 'حذف المنتج من المفضله', 'هل تريد حقا حذف المنتج من التفضيلات', (){ StoreAppCubit.get(context).removeFromWishList(model.wishListId);});
              }
          ),
        ),
      ),
    ],
  ),
);