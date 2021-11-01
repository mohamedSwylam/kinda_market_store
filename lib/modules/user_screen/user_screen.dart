
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/order_screen/orders_screen.dart';
import 'package:kinda_store/modules/wishlist_screen/wishlist_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:list_tile_switch/list_tile_switch.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';


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
    return Scaffold(
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
                      gradient: LinearGradient(
                          colors: [
                            Colors.grey[300],
                            Colors.grey[300],
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
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
                                    image: DecorationImage(
                                      fit: BoxFit.fill ,
                                      image: NetworkImage(StoreAppCubit.get(context).profileImage ??
                                          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  // 'top.toString()',
                                  StoreAppCubit.get(context).name == null ? 'ضيف' : StoreAppCubit.get(context).name,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      background: Image(
                        image: NetworkImage(StoreAppCubit.get(context).profileImage ??
                            'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                        fit: BoxFit.fill,
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
                    SizedBox(height: 40,),
                    userTitle('حقيبه المستخدم'),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10,),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
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
                                  Icons.arrow_back_ios_outlined,size: 18,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  'المفضله',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image:DecorationImage(
                                      image:   AssetImage('assets/images/wishlist.png')
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          navigateTo(context, CartScreen());
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,size: 18,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  'العربه',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 33,),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  image:DecorationImage(
                                      image:   AssetImage('assets/images/cart.png')
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          navigateTo(context, OrderScreen());
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,size: 18,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0,right: 15),
                                child: Text(
                                  'الطلبات',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 33,),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    image:DecorationImage(
                                        image:   AssetImage('assets/images/order.png')
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle('معلومات المستخدم')),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15,),
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
                                      'اسم المستخدم',
                                      style:
                                      Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${ StoreAppCubit.get(context).name}',
                                      style:
                                      Theme.of(context).textTheme.caption,
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
                                    horizontal: 20.0,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'البريد الالكتروني',
                                      style:
                                      Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${ StoreAppCubit.get(context).email}',
                                      style:
                                      Theme.of(context).textTheme.caption,
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
                                      'رقم الهاتف',
                                      style:
                                      Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${ StoreAppCubit.get(context).phone}',
                                      style:
                                      Theme.of(context).textTheme.caption,
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
                                      'عنوان المستخدم',
                                      style:
                                      Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${ StoreAppCubit.get(context).address}',
                                      style:
                                      Theme.of(context).textTheme.caption,
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
                                      'تاريخ الانضمام',
                                      style:
                                      Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${ StoreAppCubit.get(context).joinedAt}',
                                      style:
                                      Theme.of(context).textTheme.caption,
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
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: userTitle('الاعدادات'),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    ListTileSwitch(
                      contentPadding: EdgeInsets.only(left: 20),
                      value: StoreAppCubit.get(context).isDark ? true:false,
                      leading: Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: Icon(Ionicons.md_moon),
                      ),
                      onChanged: (value) {
                        StoreAppCubit.get(context).changeThemeMode();
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,

                      switchActiveColor: Colors.teal,
                      title: Text('مظهر داكن ',style: TextStyle(fontSize: 20),),
                    ),
                    SizedBox(height: 10,),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          showDialogg(context, 'تسجيل الخروج',
                              'هل تريد حقا تسجيل الخروج', () {
                                StoreAppCubit.get(context).signOut(context);
                              });
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,size: 18,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  'تسجيل الخروج',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              )
            ],
          ),
          _buildFab()
        ],
      ),
    );
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

    return Positioned(
      top: top,
      right: 18.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.yellow[700],
          heroTag: "btn1",
          onPressed: () {

          },
          child: Icon(Icons.camera_alt_outlined),
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
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontSize: 18),
      ),
    );
  }
}
