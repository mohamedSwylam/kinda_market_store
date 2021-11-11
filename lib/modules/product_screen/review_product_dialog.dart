import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';

import 'package:kinda_store/shared/styles/color.dart';


class ReviewProductDialog extends StatelessWidget {
  final String productId;
  const ReviewProductDialog({this.productId});
  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Dialog(
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
                  'تقييم المنتج',
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
                      textDirection: TextDirection.rtl,
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
                          'رائع',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ممتاز',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'جيد',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'لم يعجبني',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'سئ',
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
                              hintText: ' ... اكتب تقييمك',
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
                              text: commentController.text,
                              productId: productId);
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
                              'اضف تقييمك',
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
        );
      },
    );
  }

}
