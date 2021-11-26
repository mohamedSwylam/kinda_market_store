import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/models/comment_model.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/modules/product_screen/review_product_dialog.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  const ProductDetailsScreen({this.productId});

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    StoreAppCubit.get(context).getComments(productId);
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {
        if (state is WriteCommentSuccessState) {
          StoreAppCubit.get(context).getComments(productId);
        }
      },
      builder: (context, state) {
        var productAttr = StoreAppCubit.get(context).findById(productId);
        var cubit = StoreAppCubit.get(context);
        return Directionality(
            textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
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
                SizedBox(
                  width: 3.w,
                ),
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
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 11),
                child: Text(
                  cubit.getTexts('productDetails1'),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Image.network(
                productAttr.imageUrl,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.38,
                errorBuilder:(context,child,progress){
                  return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                },
                loadingBuilder:(context,child,progress){
                  return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                },
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
                              height: 4.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                cubit.isEn? productAttr.titleEn:productAttr.title,
                                maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 20.sp),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    cubit.getTexts('cart2'),
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 17.sp),
                                  ),
                                  Text(
                                    '${productAttr.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 17.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                cubit.isEn? productAttr.descriptionEn:productAttr.description,
                                maxLines: 15,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 13.sp),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 2.h,
                            ),
                            myDivider(),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      cubit.getTexts('productDetails2'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    StoreAppCubit.get(context).comments.length == 0 ? Container(
                                      width: double.infinity,
                                      height: 15.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            cubit.getTexts('productDetails3'),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                color: Colors.black,
                                                fontSize: 17.sp),
                                          ),
                                          Text(
                                            cubit.getTexts('productDetails4'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ) : Container(
                                      width: double.infinity,
                                      height: 40.h,
                                      child: ListView.separated(
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var list = StoreAppCubit.get(context)
                                                .comments;
                                            return buildCommentItem(
                                              context,
                                              list[index],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: 0.h,),
                                          itemCount: StoreAppCubit.get(context)
                                              .comments
                                              .length),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      child: RaisedButton(
                                        onPressed:  () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>  ReviewProductDialog(productId: productId,title: productAttr.title,),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(color: defaultColor),
                                        ),
                                        color: defaultColor,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cubit.getTexts('productDetails5'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context).textSelectionColor,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Icon(Feather.plus,size: 5.w,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                cubit.getTexts('productDetails6'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                height: 65.5.h,
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var list =
                                        StoreAppCubit.get(context).products;
                                    return buildSuggestProduct(
                                        context, list[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 5.w,),
                                  itemCount: StoreAppCubit.get(context).products.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
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
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none),
                                  color: Colors.yellow[700],
                                  onPressed: StoreAppCubit.get(context)
                                          .carts
                                          .any((element) =>
                                              element.productId == productId)
                                      ? () {}
                                      : () {
                                          StoreAppCubit.get(context)
                                              .addItemToCart(
                                                  productId: productId,
                                                  title: productAttr.title,
                                                  titleEn: productAttr.titleEn,
                                                  price: productAttr.price,
                                                  imageUrl:
                                                      productAttr.imageUrl);
                                        },
                                  child: Text(
                                    StoreAppCubit.get(context).carts.any(
                                            (element) =>
                                                element.productId == productId)
                                        ?  '${cubit.getTexts('feedsDia3')}'.toUpperCase()
                                        :  '${cubit.getTexts('feedsDia4')}'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  height: 50,
                                  child: RaisedButton(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide.none),
                                    color: Theme.of(context).backgroundColor,
                                    onPressed: () {
                                      StoreAppCubit.get(context).addItemToCart(
                                          productId: productId,
                                          title: productAttr.title,
                                          titleEn: productAttr.titleEn,
                                          price: productAttr.price,
                                          imageUrl: productAttr.imageUrl);
                                      StoreAppCubit.get(context).selectedCart();
                                      navigateTo(context, StoreLayout());
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                    cubit.getTexts('productDetails7'),
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Theme.of(context)
                                                  .textSelectionColor),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Icon(
                                          Icons.payment,
                                          color: Colors.green.shade700,
                                          size: 4.5.w,
                                        ),
                                      ],
                                    ),
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
                                  onTap: StoreAppCubit.get(context)
                                          .wishList
                                          .any((element) =>
                                              element.productId == productId)
                                      ? () {}
                                      : () {
                                          StoreAppCubit.get(context)
                                              .addToWishList(
                                            productId: productId,
                                            title: productAttr.title,
                                            titleEn: productAttr.titleEn,
                                            price: productAttr.price,
                                            imageUrl: productAttr.imageUrl,
                                            userId:
                                                StoreAppCubit.get(context).uId,
                                          );
                                        },
                                  child: Center(
                                    child: Icon(
                                      StoreAppCubit.get(context).wishList.any(
                                              (element) =>
                                                  element.productId ==
                                                  productId)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: StoreAppCubit.get(context)
                                              .wishList
                                              .any((element) =>
                                                  element.productId ==
                                                  productId)
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
        ));
      },
    );
  }
}

Widget buildCommentItem(context, CommentModel model) {
  var cubit=StoreAppCubit.get(context);
  return Directionality(
    textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${model.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 18.w,
                          height: 6.7.h,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${model.rate}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.w),
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 5.w,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              cubit.getTexts('productDetails8'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 12.sp, color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${cubit.isEn?model.rateDescriptionEn:model.rateDescription}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 12.sp, color: defaultColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '${model.text} ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 12.sp, color: defaultColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 8.w,
                backgroundImage: NetworkImage('${model.imageUrl}'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

 Widget buildSuggestProduct(context, Product model) {
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
       child:  Container(
         width: 70.w,
         clipBehavior: Clip.antiAliasWithSaveLayer,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20.0),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Stack(
               children: [
                 Container(
                   width: double.infinity,
                   height: 40.h,
                   child: Image.network(
                     model.imageUrl,
                     errorBuilder:(context,child,progress){
                       return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                     },
                     loadingBuilder:(context,child,progress){
                       return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                     },
                     fit: BoxFit.fill,
                   ),
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
             Container(
               color: Colors.white,
               width: double.infinity,
               height: 6.h,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                 child: Text(
                   cubit.isEn?model.titleEn:model.title,
                   textAlign: TextAlign.end,
                   style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.bold,
                     fontSize: 13.sp,
                   ),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
               ),
             ),
             Container(
               color: Colors.white,
               width: double.infinity,
               height: 9.h,
               child: Padding(
                 padding: const EdgeInsets.only(left: 8.0,right:8 ,bottom: 5),
                 child: Text(
                   cubit.isEn? model.descriptionEn:model.description,
                   style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                   maxLines: 2,
                   textAlign: TextAlign.end,
                   overflow: TextOverflow.ellipsis,
                 ),
               ),
             ),
             Container(
               height: 7.h,
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
                       size: 20.sp,
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
                       size: 20.sp,
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
           ],
         ),
       ),
     ),
   );
 }
