import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';



class FeedsDialog extends StatelessWidget {
  final String productId;
  const FeedsDialog({this.productId});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var productAttr=StoreAppCubit.get(context).findById(productId);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Image.network(
                  StoreAppCubit.get(context).findById(productId).imageUrl,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: dialogContent(
                              context,
                              0,
                            StoreAppCubit.get(context)
                                .wishList.any((element) => element.productId==productId)? (){}:() {
                              StoreAppCubit.get(context)
                                  .addToWishList(
                                productId: productId,
                                title:  productAttr.title,
                                price: productAttr.price,
                                imageUrl:  productAttr.imageUrl ,
                                userId: StoreAppCubit.get(context).uId,
                              );
                            },
                          ),
                        ),
                        Flexible(
                          child: dialogContent(
                              context,
                              1,
                                  ()  {
                               //   navigateTo(context, ProductDetailsScreen(productId: productId,));
                              }),
                        ),
                        Flexible(
                          child: dialogContent(
                            context,
                            2,
                              StoreAppCubit.get(context).carts.any((element) => element.productId==productId)? (){}:() {
                              StoreAppCubit.get(context).addItemToCart(productId: productId,title:  productAttr.title, price: productAttr.price, imageUrl: productAttr.imageUrl);
                            },
                          ),
                        ),
                      ]),
                ),
              ),

              /************close****************/
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.3),
                    shape: BoxShape.circle),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.grey,
                    onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close, size: 28, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
  Widget dialogContent(BuildContext context, int index, Function function) {
    List<IconData> dialogIcons = [
      StoreAppCubit.get(context)
          .wishList.any((element) => element.productId==productId)
          ? Icons.favorite
          : Icons.favorite_border,
      Feather.eye,
      Feather.shopping_cart,
    ];

    List<String> texts = [
      StoreAppCubit.get(context)
          .wishList.any((element) => element.productId==productId)
          ? 'في المفضلة'
          : 'اضف للمفضلة',
      'فتح المنتج',
      StoreAppCubit.get(context)
          .carts.any((element) => element.productId==productId) ? 'في العربه' : 'اضف للعربه',
    ];
    List<Color> colors = [
      StoreAppCubit.get(context)
          .wishList.any((element) => element.productId==productId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
      StoreAppCubit.get(context)
          .carts.any((element) => element.productId==productId)
          ? defaultColor
          : Theme.of(context).textSelectionColor,    ];
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: function,
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          dialogIcons[index],
                          color: colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: StoreAppCubit.get(context).isDark
                            ? Theme.of(context).disabledColor
                            : ColorsConsts.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
