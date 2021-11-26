import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/order_screen/orders_screen.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserScreen> {
  ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  String _name;
  String _email;
  String _joinedAt;
  String _userImageUrl;
  int _phoneNumber;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser;
    _uid = user.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _name = userDoc.get('name');
        _email = user.email;
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
    // print("name $_name");
  }

  @override
  Widget build(BuildContext context) {
    var cubit = StoreAppCubit.get(context);
    return Directionality(
        textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
        child: Scaffold(
        body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top <= 110.0 ? 1.0 : 0,
                            child: Row(
                              children: [
                                Container(
                                  child: Image.network(StoreAppCubit.get(
                                      context)
                                      .profileImage ??
                                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                                    fit: BoxFit.fill,
                                    errorBuilder:(context,child,progress){
                                      return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                                    },
                                    loadingBuilder:(context,child,progress){
                                      return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                                    },
                                  ),
                                  height: kToolbarHeight / 1.8,
                                  width: kToolbarHeight / 1.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  // 'top.toString()',
                                  StoreAppCubit.get(context).name == null
                                      ?  cubit.getTexts('user1')
                                    : StoreAppCubit.get(context).name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      background: Image.network(StoreAppCubit.get(context)
                          .profileImage ??
                          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                        fit: BoxFit.fill,
                        errorBuilder:(context,child,progress){
                          return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                        },
                        loadingBuilder:(context,child,progress){
                          return progress == null  ? child : SpinKitChasingDots(size: 50,color: defaultColor,);
                        },
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    userTitle(cubit.getTexts('user2'),),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, WishListScreen());
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 5.w,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  cubit.getTexts('user3'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/wishlist.png')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, CartScreen());
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 5.w,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  cubit.getTexts('user4'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/cart.png')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, OrderScreen());
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 5.w,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 15),
                                child: Text(
                                  cubit.getTexts('user5'),                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/order.png')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle(cubit.getTexts('user6'),),),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.getTexts('user7'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${StoreAppCubit.get(context).name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.person),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.getTexts('user8'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${StoreAppCubit.get(context).email}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.email),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.getTexts('user9'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${StoreAppCubit.get(context).phone}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.phone),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.getTexts('user10'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${StoreAppCubit.get(context).address}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.local_shipping),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit.getTexts('user11'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${StoreAppCubit.get(context).joinedAt}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.watch_later),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: userTitle(cubit.getTexts('user12'),),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            cubit.getTexts('user13'),
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          FlutterSwitch(
                            width: 13.0.w,
                            height: 4.h,
                            toggleSize: 16.0.sp,
                            value: StoreAppCubit.get(context).isDark ? true : false,
                            borderRadius: 30.0,
                            padding: 0.0,
                            activeToggleColor: Colors.white,
                            inactiveToggleColor: Colors.white,
                            activeColor: Colors.grey,
                            inactiveColor: Colors.grey,
                            onToggle: (value) {
                              StoreAppCubit.get(context).changeThemeMode();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            cubit.getTexts('user14'),
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          FlutterSwitch(
                            width: 13.0.w,
                            height: 4.h,
                            toggleSize: 16.0.sp,
                            value: StoreAppCubit.get(context).isEn ? true : false,
                            borderRadius: 30.0,
                            padding: 0.0,
                            activeToggleColor: Colors.white,
                            inactiveToggleColor: Colors.white,
                            activeColor: Colors.grey,
                            inactiveColor: Colors.grey,
                            onToggle: (value) {
                              StoreAppCubit.get(context).changeLanguage();
                              StoreAppCubit.get(context).getLan();
                              StoreAppCubit.get(context).selectedHome();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showDialoggLogout(context, cubit.getTexts('user15'),
                              cubit.getTexts('user16'), () {
                            StoreAppCubit.get(context).signOut(context);
                          });
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 15),
                                child: Text(
                                    cubit.getTexts('user15'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 15.sp),
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/1828/1828404.png',
                                width: 11.w,
                                height: 11.h,
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
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
          _buildFab()
        ],
      ),
    ));
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }
    var cubit = StoreAppCubit.get(context);
    return Directionality(
      textDirection: cubit.isEn == false? TextDirection.ltr :TextDirection.rtl,
      child: Positioned(
        top: top,
        right: 18.0,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: FloatingActionButton(
            backgroundColor: Colors.yellow[700],
            heroTag: "btn1",
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          cubit.getTexts('signUp1'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: defaultColor,
                              fontSize: 13.sp),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            InkWell(
                              onTap: () {
                                StoreAppCubit.get(context).pickImageCamera();
                                Navigator.pop(context);
                              },
                              splashColor: defaultColor,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera,
                                      color: Colors.yellow[700],
                                      size: 7.w,
                                    ),
                                  ),
                                  Text(
                                    cubit.getTexts('signUp2'),
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsConsts.title),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                StoreAppCubit.get(context).getProfileImage();
                                Navigator.pop(context);
                              },
                              splashColor: defaultColor,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.image,
                                      size: 7.w,
                                      color: Colors.yellow[700],
                                    ),
                                  ),
                                  Text(
                                    cubit.getTexts('signUp3'),
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsConsts.title),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                StoreAppCubit.get(context).remove();
                                Navigator.pop(context);
                              },
                              splashColor: defaultColor,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                      size: 7.w,
                                    ),
                                  ),
                                  Text(
                                    cubit.getTexts('signUp4'),
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Icon(
              Icons.camera_alt_outlined,
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          onTap: () {},
          title: Text(title),
          subtitle: Text(subTitle),
          leading: Icon(_userTileIcons[index]),
        ),
      ),
    );
  }

  Widget userTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.h),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15.sp),
      ),
    );
  }
}
