import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kinda_store/shared/components/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';

import 'package:kinda_store/shared/styles/color.dart';


class ReviewProductDialog extends StatelessWidget {
  final String productId;
  final String title;
  const ReviewProductDialog({this.productId,this.title});
  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = StoreAppCubit.get(context);
        return Directionality(
          textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  width: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                    Text(
                      cubit.getTexts('productDetails2'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600),),
                      SizedBox(
                        height: 4.h,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        itemSize: 8.w,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        textDirection: cubit.isEn==false ? TextDirection.rtl:TextDirection.ltr,
                        itemPadding:
                        EdgeInsets.symmetric(horizontal: 12.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.yellow[700],
                        ),
                        onRatingUpdate: (rating)=>StoreAppCubit.get(context).changeRating(rating),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            cubit.getTexts('productReview1'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cubit.getTexts('productReview2'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cubit.getTexts('productReview3'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cubit.getTexts('productReview4'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cubit.getTexts('productReview5'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow[700],
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: TextFormField(
                              controller: commentController,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:  '${cubit.getTexts('productReview6')}',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: RaisedButton(
                          onPressed:  ()  {
                            StoreAppCubit.get(context)
                                .writeComment(
                                dateTime: formattedDate,
                                rate: StoreAppCubit.get(context).rate,
                                rateDescription: StoreAppCubit.get(context).rateDescription,
                                rateDescriptionEn: StoreAppCubit.get(context).rateDescriptionEn,
                                text: commentController.text,
                                productId: productId);
                            StoreAppCubit.get(context).pushNotification(title:'تقييم جديد',body:' قام ${StoreAppCubit.get(context).name} بتقييم منتج ${title}',token: y9ksc,);
                            StoreAppCubit.get(context).pushNotification(title:'تقييم جديد',body:' قام ${StoreAppCubit.get(context).name} بتقييم منتج ${title}',token: karima,);
                            Navigator.pop(context);
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
                      SizedBox(height: 4.h,),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

}
