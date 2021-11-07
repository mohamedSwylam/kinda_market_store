import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';


class BackLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BlocConsumer<StoreAppCubit,StoreAppStates> (
      listener: (context,state){},
      builder: (context,state){
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Positioned(
              top: -100.0,
              left: 140.0,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  width: 150,
                  height: 250,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 100.0,
              child: Transform.rotate(
                angle: -0.8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  width: 150,
                  height: 300,
                ),
              ),
            ),
            Positioned(
              top: -50.0,
              left: 60.0,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  width: 150,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 0.0,
              child: Transform.rotate(
                angle: -0.8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  width: 150,
                  height: 200,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CircleAvatar(
                              backgroundImage:  NetworkImage(StoreAppCubit.get(context).profileImage ??
        'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                              radius: 10.w,
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'مرحبا',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 13.sp),
                            ),
                            Text(
                              '${StoreAppCubit.get(context).name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 13.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'معلومات عنا',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 15.sp),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 39.w,
                          child: Text(
                            'اشمون  ميدان فليفل خلف صيدليه الحكمه',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 12.sp,color: Colors.red[700]),

                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            'العنوان',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  launch("tel:01229369779");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 6.w,
                                    ),
                                    SizedBox(width: 10.w,),
                                    Text(
                                      '01229369779',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp,color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h,),
                              InkWell(
                                onTap: (){
                                  launch("tel:01093717500");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 6.w,
                                    ),
                                    SizedBox(width: 10.w,),
                                    Text(
                                      '01093717500',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp,color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            'ارقام التواصل',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          child: InkWell(
                            onTap: ()=>StoreAppCubit.get(context).openWattsAppChat(),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesome.whatsapp,color: Colors.green[700],size: 6.w,
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  '01093717500',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12.sp,color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            'واتساب',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          child: InkWell(
                            onTap: ()=> launch("https://www.facebook.com/groups/2123012787993306"),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesome.facebook,color: Colors.blue[700],size: 6.w,
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  'Kinda Cheese',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12.sp,color: Colors.blue[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            'فيسبوك',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          child: InkWell(
                            onTap: ()=> launch("tel:01093717500"),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,color: Colors.green[700],size: 6.w,
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  'Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12.sp,color: Colors.red[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            'Gps',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
