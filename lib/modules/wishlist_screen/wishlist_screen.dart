import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/wishlist_model.dart';
import 'package:kinda_store/shared/components/components.dart';

import 'empty_wishlist.dart';

class WishListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return StoreAppCubit.get(context).wishList.isEmpty
              ? Scaffold(
            body: EmptyWishList(),
          )
              : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                 // showDialogg(context, 'تنظيف المفضله', 'هل تريد حقل حذف جميع المنتجات من تفضيلاتك', (){ StoreAppCubit.get(context).clearWishList();});
                },
                icon: Icon(
                  Feather.trash,
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 1,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 11),
                  child: Text(
                    'المفضله (${StoreAppCubit.get(context).wishList.length})',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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