import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/models/banner_model.dart';
import 'package:kinda_store/models/comment_model.dart';
import 'package:kinda_store/models/user_model.dart';
import 'package:kinda_store/models/watched_product_model.dart';
import 'package:kinda_store/modules/search/search_screen.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/cart_model.dart';
import 'package:kinda_store/models/category_model.dart';
import 'package:kinda_store/models/order_model.dart';
import 'package:sizer/sizer.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/models/wishlist_model.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/feeds_screen/feeds_screen.dart';
import 'package:kinda_store/modules/home_screen/home_screen.dart';
import 'package:kinda_store/modules/landingPage/landing_page.dart';
import 'package:kinda_store/modules/user_screen/user_screen.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
import 'package:kinda_store/shared/network/remote/dio_helper.dart';
import 'package:kinda_store/shared/network/remote/end_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../store_layout.dart';

class StoreAppCubit extends Cubit<StoreAppStates> {
  StoreAppCubit() : super(StoreInitialState());

  static StoreAppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> StoreScreens = [
    HomeScreen(),
    FeedsScreen(),
    SearchScreen(),
    CartScreen(),
    UserScreen(),
  ];

  void selectedHome() {
    currentIndex = 0;
    emit(StoreAppBottomBarHomeState());
  }

  void selectedCart() {
    currentIndex = 3;
    emit(StoreAppBottomBarCartState());
  }

  void selectedSearch() {
    currentIndex = 2;
    emit(StoreAppBottomBarSearchState());
  }

  void selectedUser() {
    currentIndex = 4;
    emit(StoreAppBottomBarUserState());
  }

  bool isDark = false;

  void changeThemeMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(StoreAppChangeThemeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(StoreAppChangeThemeModeState());
      });
    }
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(StoreChangeBottomNavState());
  }

  String dropDownValue = '1';
  var items = ['1', '2', '3', '4', '5', '6'];

  void changeDropDownValue(String newValue) {
    dropDownValue = newValue;
    emit(StoreChangeDropdownState());
  }

  void openWattsAppChat() async {
    await launch('http://wa.me/+201093717500?text=?????????? ?????? ???? ???????? ???????? ');
  }

  ///////////////write comment

  void writeComment({
    @required String dateTime,
    @required String text,
    @required String rateDescription,
    @required String rateDescriptionEn,
    @required double rate,
    @required String productId,
  }) {
    final commentId = uuid.v4();
    emit(WriteCommentLoadingState());
    CommentModel model = CommentModel(
      userId: uId,
      imageUrl: profileImage ??
          "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png",
      dateTime: dateTime,
      productId: productId,
      rate: rate ?? 3,
      rateDescription: rateDescription ?? '??????',
      rateDescriptionEn: rateDescriptionEn ?? 'Good',
      commentId: commentId,
      username: name,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .set(model.toMap())
        .then((value) {
      emit(WriteCommentSuccessState());
    }).catchError((error) {
      emit(WriteCommentErrorState());
    });
  }

  List<CommentModel> comments = [];

  void getComments(
    @required String productId,
  ) async {
    emit(GetCommentsLoadingStates());
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('comments')
        .get()
        .then((QuerySnapshot commentsSnapshot) {
      comments.clear();
      commentsSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        comments.insert(
          0,
          CommentModel(
            userId: element.get('userId'),
            dateTime: element.get('dateTime'),
            commentId: element.get('commentId'),
            imageUrl: element.get('imageUrl'),
            username: element.get('username'),
            rate: element.get('rate'),
            rateDescription: element.get('rateDescription'),
            rateDescriptionEn: element.get('rateDescriptionEn'),
            productId: element.get('productId'),
            text: element.get('text'),
          ),
        );
      });
      emit(GetCommentsSuccessStates());
    }).catchError((error) {
      emit(GetCommentsErrorStates());
    });
  }

  double rate;

  String rateDescription;
  String rateDescriptionEn;

  void changeRating(rating) {
    rate = rating;
    if (rating > 0 && rating <= 1) {
      rateDescription = '????';
      rateDescriptionEn = 'Bad';
    } else if (rating > 1 && rating <= 2) {
      rateDescription = '???? ????????????';
      rateDescriptionEn = 'Dislike';
    } else if (rating > 2 && rating <= 3) {
      rateDescription = '??????';
      rateDescriptionEn = 'Good';
    } else if (rating > 3 && rating <= 4) {
      rateDescription = '??????????';
      rateDescriptionEn = 'Excellent';
    } else if (rating > 4 && rating <= 5) {
      rateDescription = '????????';
      rateDescriptionEn = 'Amazing';
    } else {
      rate = 3.0;
      rateDescription = "??????";
      rateDescriptionEn = 'Good';
    }
    print(rating);
    emit(ChangeRateSuccessStates());
  }

  //////////////////////////////////Notification

  void pushNotification({
    @required String token,
    @required String title,
    @required String body,
  }) {
    emit(PushNotificationLoadingState());
    DioHelper.postData(
      url: NOTIFICATION,
      data: {
        'to': token,
        'notification': {"title": title, "body": body, "sound": "default"},
        "android": {
          "priority": "HIGH",
          "notification": {
            "default_sound": true,
            "notification_priority": "PRIORITY_MAX",
            "sound": "default",
            "default_vibrate_timings": true,
            "default_light_settings": true
          },
          "data": {
            "type": "order",
            "id": "1",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        }
      },
    ).then((value) {
      emit(PushNotificationSuccessState());
    }).catchError((error) {
      emit(PushNotificationErrorState());
    });
  }

  ///////////////////////////SignUp
  void userSignUp({
    @required String password,
    @required String email,
    @required String name,
    @required String phone,
    @required String address,
    @required String joinedAt,
    @required String createdAt,
    @required String profileImage,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        uId: value.user.uid,
        name: name,
        address: address,
        email: email,
        phone: phone,
        joinedAt: joinedAt,
        createdAt: createdAt,
        profileImage: profileImage,
      );
      print(value.user.email);
      print(value.user.uid);
      emit(SignUpSuccessState());
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
    });
  }

  void createUser({
    String name,
    String uId,
    String phone,
    String email,
    String address,
    String joinedAt,
    String createdAt,
    String profileImage,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: uId,
      profileImage: profileImage,
      address: address,
      createdAt: createdAt,
      joinedAt: joinedAt,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData prefix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    prefix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(SignUpPasswordVisibilityState());
  }

  File profile;
  String url;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile = File(pickedFile.path);
      uploadProfileImage();
      emit(SignUpPickedProfileImageSuccessState());
    } else {
      print('No image selected.');
      emit(SignUpPickedProfileImageErrorState());
    }
  }

  void uploadProfileImage() {
    emit(UploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profile.path).pathSegments.last}')
        .putFile(profile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadPickedProfileImageSuccessState());
        updateUser(
          name: name,
          address: address,
          joinedAt: joinedAt,
          email: email,
          phone: phone,
          profileImage: value,
          uId: uId,
          createdAt: createdAt,
        );
        url = value;
        print(value);
        emit(UploadPickedProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadPickedProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadPickedProfileImageErrorState());
    });
  }

  void pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(profile.path);
    profile = pickedImageFile;
    uploadProfileImage();
    emit(SignUpPickedProfileImageCameraSuccessState());
  }

  void remove() {
    url =
        'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
    uploadProfileImage();
    emit(SignUpRemoveProfileImageSuccessState());
  }

  ///////////////////////////// login Screen
  void userLogin({
    @required String password,
    @required String email,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      getUserData();
      getOrders();
      getWishList();
      getWatchedProducts();
      getCarts();
      print(value.user.email);
      print(value.user.uid);
      emit(LoginSuccessState(value.user.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  void userForgetPassword({
    @required String email,
  }) {
    emit(ForgetPasswordLoadingState());
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.trim().toLowerCase())
        .then((value) {
      emit(ForgetPasswordSuccessState());
    }).catchError((error) {
      emit(ForgetPasswordErrorState(error.toString()));
    });
  }

  void userLoginAnonymous(context) {
    emit(LoginAnonymousLoadingState());
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    FirebaseAuth.instance.signInAnonymously().then((value) {
      name = StoreAppCubit.get(context).isEn ? 'Gust' : '????????';
      email = StoreAppCubit.get(context).isEn
          ? 'Without email address'
          : '???????? ???????? ????????????????';
      joinedAt = formattedDate;
      phone = StoreAppCubit.get(context).isEn
          ? 'Without phone number'
          : '???????? ?????? ????????';
      address =
          StoreAppCubit.get(context).isEn ? 'Without address' : '???????? ??????????';
      profileImage =
          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
      createdAt = Timestamp.now().toString();
      getUserData();
      getOrders();
      getWishList();
      getCarts();
      CacheHelper.saveData(key: 'uId', value: value.user.uid).then((value) {
        navigateAndFinish(context, StoreLayout());
      });
      emit(LoginAnonymousSuccessState());
    }).catchError((error) {
      emit(LoginAnonymousErrorState(error.toString()));
    });
  }

  void updateUser({
    String name,
    String phone,
    String email,
    String uId,
    String profileImage,
    String address,
    String joinedAt,
    String createdAt,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: uId,
      profileImage: profileImage,
      address: address,
      createdAt: createdAt,
      joinedAt: joinedAt,
    );
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'profileImage': profileImage,
      'joinedAt': joinedAt,
      'createdAt': createdAt,
      'address': address,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateErrorState(error.toString()));
    });
  }

/*  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(LoginPasswordVisibilityState());
  }*/

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name;
  String phone;
  String email;
  String uId;
  String profileImage;
  String address;
  String joinedAt;
  String createdAt;

  void getUserData() async {
    emit(GetUserLoginLoadingStates());
    User user = _auth.currentUser;
    uId = user.uid;
    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();
    if (userDoc == null) {
      return;
    } else {
      name = userDoc.get('name');
      email = user.email;
      joinedAt = userDoc.get('joinedAt');
      phone = userDoc.get('phone');
      address = userDoc.get('address');
      profileImage = userDoc.get('profileImage');
      createdAt = userDoc.get('createdAt');
      emit(GetUserLoginSuccessStates());
    }
  }

  Future<void> googleSignIn(context) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          createUser(
            uId: googleAccount.id,
            profileImage: googleAccount.photoUrl,
            phone: '',
            email: googleAccount.email,
            joinedAt: formattedDate,
            createdAt: Timestamp.now().toString(),
            address: '',
            name: googleAccount.email,
          );
          name = googleAccount.displayName;
          email = googleAccount.email;
          joinedAt = formattedDate;
          phone = '';
          address = '';
          profileImage = googleAccount.photoUrl;
          createdAt = Timestamp.now().toString();
          getUserData();
          getCarts();
          getWishList();
          getWatchedProducts();
          getOrders();
          CacheHelper.saveData(key: 'uId', value: googleAccount.id).then((value) {
            navigateAndFinish(context, StoreLayout());
          });
        } catch (error) {
          authErrorHandle(error.message, context);
        }
      }
    }
  }

  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/564/564619.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  ///////////
  List<OrderModel> orders = [];

  void getOrders() async {
    emit(GetOrdersLoadingStates());
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uId)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      orders.clear();
      ordersSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        orders.insert(
          0,
          OrderModel(
            orderId: element.get('orderId'),
            title: element.get('title'),
            titleEn: element.get('titleEn'),
            imageUrl: element.get('imageUrl'),
            products: element.get('products'),
            prices: element.get('prices'),
            quantities : element.get('quantities'),
            productsEn: element.get('productsEn'),
            userId: element.get('userId'),
            userAddress: element.get('userAddress'),
            total: element.get('total'),
            subTotal: element.get('subTotal'),
            anotherNumber: element.get('anotherNumber'),
            addressDetails: element.get('addressDetails'),
            username: element.get('username'),
            userPhone: element.get('userPhone'),
          ),
        );
      });
      emit(GetOrdersSuccessStates());
    }).catchError((error) {
      emit(GetOrdersErrorStates());
    });
  }
  OrderModel findByOrderId(String orderId) {
    return orders.firstWhere((element) => element.orderId == orderId);
  }
  void removeOrder(orderId) async {
    emit(RemoveOrderLoadingStates());
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .delete()
        .then((_) {
      getOrders();
      emit(RemoveOrderSuccessStates());
    }).catchError((error) {
      emit(RemoveOrderErrorStates());
    });
  }

//////////////get banners
  List banners = [];

  void getBanners() async {
    emit(GetBannersLoadingStates());
    await FirebaseFirestore.instance
        .collection('banners')
        .get()
        .then((QuerySnapshot bannersSnapshot) {
      banners = [];
      bannersSnapshot.docs.forEach((element) {
        banners.insert(
          0,
          BannerModel(
            id: element.get('id'),
            imageUrl: element.get('imageUrl'),
          ),
        );
      });
      emit(GetBannersSuccessStates());
    }).catchError((error) {
      emit(GetBannersErrorStates(error.toString()));
    });
  }

  //////////////////////////facebook Login
  var loading = false;

  void logInWithFacebook(context) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    loading = true;
    emit(LoginWithFacebookLoadingStates());
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken.token);
      await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential)
          .then((value) {
        createUser(
          uId: value.user.uid,
          name: userData['name'],
          address: '',
          email: userData['email'],
          phone: '',
          joinedAt: formattedDate,
          createdAt: Timestamp.now().toString(),
          profileImage: userData['picture']['data']['url'],
        );
        getUserData();
        getOrders();
        getWishList();
        getWatchedProducts();
        getCarts();
        CacheHelper.saveData(key: 'uId', value: value.user.uid).then((value) {
          navigateAndFinish(context, StoreLayout());
        });
      });
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with facebook failed'),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } finally {
      loading = false;
      emit(LoginWithFacebookSuccessStates());
    }
  }

  ////////////////////////////////////
  List<Product> popularProducts = [];

  Product findById(String productId) {
    return products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    List categoryList = products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<Product> findByCategoryEn(String categoryName) {
    List categoryList = products
        .where((element) => element.productCategoryNameEn
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  var uuid = Uuid();

  void addItemToCart({
    String productId,
    String title,
    String titleEn,
    double price,
    String imageUrl,
    String userId,
    int quantity,
  }) {
    final cartId = uuid.v4();
    FirebaseFirestore.instance.collection('carts').doc(cartId).set({
      'productId': productId.toString(),
      'userId': uId.toString(),
      'cartId': cartId.toString(),
      'title': title,
      'titleEn': titleEn,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': 1,
    }).then((value) {
      getCarts();
      emit(CreateCartItemSuccessState());
    }).catchError((error) {
      emit(CreateCartItemErrorState());
    });
  }

  List<CartModel> carts = [];
  void getCarts() async {
    emit(GetCartsLoadingStates());
    await FirebaseFirestore.instance
        .collection('carts')
        .where('userId', isEqualTo: uId)
        .get()
        .then((QuerySnapshot cartSnapshot) {
      carts.clear();
      cartSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        carts.insert(
          0,
          CartModel(
            cartId: element.get('cartId'),
            imageUrl: element.get('imageUrl'),
            price: element.get('price'),
            productId: element.get('productId'),
            quantity: element.get('quantity'),
            title: element.get('title'),
            titleEn: element.get('titleEn'),
            userId: element.get('userId'),
          ),
        );
      });
      emit(GetCartsSuccessStates());
    }).catchError((error) {
      emit(GetCartsErrorStates(error.toString()));
    });
  }
  double get totalAmount {
    var total = 0.0;
    carts.forEach((value) {
      total += value.price * value.quantity;
    });
    return total;
  }
  CartModel findByCartId(String cartId) {
    return carts.firstWhere((element) => element.cartId == cartId);
  }
  void removeFromCart(cartId) async {
    emit(RemoveFromCartLoadingStates());
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartId)
        .delete()
        .then((_) {
      getCarts();
      emit(RemoveFromCartSuccessStates());
    }).catchError((error) {
      emit(RemoveFromCartErrorStates());
    });
  }
  void clearCart() async {
    emit(ClearCartLoadingStates());
    await FirebaseFirestore.instance
        .collection('carts')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs.where((element) => element['userId']==uId)){
        ds.reference.delete();
      }
      getCarts();
      emit(ClearCartSuccessStates());
    }).catchError((error) {
      emit(ClearCartErrorStates());
    });
  }

  void addItemByOne(
      {String productId,
      String title,
      double price,
      String imageUrl,
      String userId,
      int quantity,
      cartId}) async {
    emit(AddCartItemByOneLoadingStates());
    await FirebaseFirestore.instance.collection('carts').doc(cartId).update({
      'productId': productId.toString(),
      'userId': uId.toString(),
      'cartId': cartId.toString(),
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    }).then((value) {
      getCarts();
      emit(AddCartItemByOneSuccessStates());
    }).catchError((error) {
      emit(AddCartItemByOneErrorStates());
    });
  }

  void reduceItemByOne(
      {String productId,
      String title,
      double price,
      String imageUrl,
      String userId,
      int quantity,
      cartId}) async {
    emit(ReduceCartItemByOneLoadingStates());
    await FirebaseFirestore.instance.collection('carts').doc(cartId).update({
      'productId': productId.toString(),
      'userId': uId.toString(),
      'cartId': cartId.toString(),
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    }).then((value) {
      getCarts();
      emit(ReduceCartItemByOneSuccessStates());
    }).catchError((error) {
      emit(ReduceCartItemByOneErrorStates());
    });
  }

  //////////////////////WishList
  void addToWishList({
    String productId,
    String title,
    String titleEn,
    double price,
    String imageUrl,
    String userId,
  }) {
    final wishListId = uuid.v4();
    FirebaseFirestore.instance.collection('wishList').doc(wishListId).set({
      'productId': productId.toString(),
      'userId': uId.toString(),
      'wishListId': wishListId.toString(),
      'title': title,
      'titleEn': titleEn,
      'price': price,
      'imageUrl': imageUrl,
    }).then((value) {
      getWishList();
      emit(UploadWishListItemSuccessState());
    }).catchError((error) {
      emit(UploadWishListItemErrorState());
    });
  }

  List<WishListModel> wishList = [];

  void getWishList() async {
    emit(GetWishListLoadingStates());
    await FirebaseFirestore.instance
        .collection('wishList')
        .where('userId', isEqualTo: uId)
        .get()
        .then((QuerySnapshot wishListSnapshot) {
      wishList.clear();
      wishListSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        wishList.insert(
          0,
          WishListModel(
            wishListId: element.get('wishListId'),
            imageUrl: element.get('imageUrl'),
            price: element.get('price'),
            productId: element.get('productId'),
            title: element.get('title'),
            titleEn: element.get('titleEn'),
            userId: element.get('userId'),
          ),
        );
      });
      emit(GetWishListSuccessStates());
    }).catchError((error) {
      emit(GetWishListErrorStates(error.toString()));
    });
  }

  void removeFromWishList(wishListId) async {
    emit(RemoveFromWishListLoadingStates());
    await FirebaseFirestore.instance
        .collection('wishList')
        .doc(wishListId)
        .delete()
        .then((_) {
      getWishList();
      emit(RemoveFromWishListSuccessStates());
    }).catchError((error) {
      emit(RemoveFromWishListErrorStates());
    });
  }

  /////////////////////////search
  List<Product> searchList = [];

  List<Product> searchQuery(String searchText) {
    searchList = products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    emit(StoreAppSearchQuerySuccessState());
    return searchList;
  }

/////////////////////////////product
  List<Product> products = [];

  void getProduct() async {
    emit(GetProductLoadingStates());
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productsSnapshot) {
      products = [];
      productsSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        products.insert(
          0,
          Product(
              id: element.get('id'),
              title: element.get('title'),
              description: element.get('description'),
              productCategoryNameEn: element.get('productCategoryName??En'),
              titleEn: element.get('titleEn'),
              descriptionEn: element.get('descriptionEn'),
              price: double.parse(
                element.get('price'),
              ),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              isPopular: true),
        );
      });
      emit(GetProductSuccessStates());
    }).catchError((error) {
      emit(GetProductErrorStates());
    });
  }

  ////////////////////////////watchedRecently
  List<WatchedModel> watchedProducts = [];

  void getWatchedProducts() async {
    emit(GetWatchedLoadingStates());
    await FirebaseFirestore.instance
        .collection('watched')
        .where('userId', isEqualTo: uId)
        .get()
        .then((QuerySnapshot watchedSnapshot) {
      watchedProducts.clear();
      watchedSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        watchedProducts.insert(
          0,
          WatchedModel(
            watchedId: element.get('watchedId'),
            description: element.get('description'),
            imageUrl: element.get('imageUrl'),
            price: element.get('price'),
            productId: element.get('productId'),
            title: element.get('title'),
            descriptionEn: element.get('descriptionEn'),
            titleEn: element.get('titleEn'),
            userId: element.get('userId'),
          ),
        );
      });
      emit(GetWatchedSuccessStates());
    }).catchError((error) {
      emit(GetWatchedErrorStates(error.toString()));
    });
  }

  void addToWatchedProduct({
    String productId,
    String title,
    String titleEn,
    String descriptionEn,
    double price,
    String imageUrl,
    String description,
    String userId,
  }) {
    final watchedId = uuid.v4();
    FirebaseFirestore.instance.collection('watched').doc(watchedId).set({
      'productId': productId.toString(),
      'userId': uId.toString(),
      'watchedId': watchedId.toString(),
      'title': title,
      'titleEn': titleEn,
      'descriptionEn': descriptionEn,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    }).then((value) {
      getWatchedProducts();
      emit(UploadWatchedItemSuccessState());
    }).catchError((error) {
      emit(UploadWatchedItemErrorState());
    });
  }

  void removeFromWatched(watchedId) async {
    emit(RemoveFromWatchedLoadingStates());
    await FirebaseFirestore.instance
        .collection('watched')
        .doc(watchedId)
        .delete()
        .then((_) {
      getWatchedProducts();
      emit(RemoveFromWatchedSuccessStates());
    }).catchError((error) {
      emit(RemoveFromWatchedErrorStates());
    });
  }

  ///////////////////////////////////Signout
  void signOut(context) => CacheHelper.removeData(key: 'uId').then((value) {
        if (value) {
          FirebaseAuth.instance
              .signOut()
              .then((value) => navigateAndFinish(context, LandingPage()));
          emit(SignOutSuccessState());
        }
      });

  ////////////////////////////////categoryScreen
  List<CategoryModel> categories = [
    CategoryModel(
        categoryName: '??????????',
        categoryImage: 'assets/images/twabl.jpg',
        categoryId: '1'),
    CategoryModel(
        categoryName: '????????????',
        categoryImage: 'assets/images/mogmdat.jpg',
        categoryId: '2'),
    CategoryModel(
        categoryName: '??????????????',
        categoryImage: 'assets/images/mshrob.jpg',
        categoryId: '3'),
    CategoryModel(
        categoryName: '????????????',
        categoryImage: 'assets/images/moslgat.jpg',
        categoryId: '4'),
    CategoryModel(
      categoryName: '??????',
      categoryImage: 'assets/images/cheese.jpg',
      categoryId: '5',
    ),
    CategoryModel(
        categoryName: '??????????',
        categoryImage: 'assets/images/sos.jpg',
        categoryId: '6'),
    CategoryModel(
        categoryName: '??????????????',
        categoryImage: 'assets/images/bread.jpg',
        categoryId: '7'),
    CategoryModel(
      categoryName: '????????????????',
      categoryId: '8',
      categoryImage: 'assets/images/choclate.jpg',
    ),
    CategoryModel(
        categoryName: '????????',
        categoryImage: 'assets/images/halwa.jpeg',
        categoryId: '9'),
    CategoryModel(
        categoryName: '????????????',
        categoryImage: 'assets/images/mksrat.gif',
        categoryId: '10'),
    CategoryModel(
        categoryName: '??????????',
        categoryImage: 'assets/images/bkala.jpg',
        categoryId: '11'),
  ];
  List<CategoryModel> categoriesEng = [
    CategoryModel(
        categoryName: 'Spices',
        categoryImage: 'assets/images/twabl.jpg',
        categoryId: '1'),
    CategoryModel(
        categoryName: 'Freezers',
        categoryImage: 'assets/images/mogmdat.jpg',
        categoryId: '2'),
    CategoryModel(
        categoryName: 'Drinks',
        categoryImage: 'assets/images/mshrob.jpg',
        categoryId: '3'),
    CategoryModel(
        categoryName: 'Ice cream',
        categoryImage: 'assets/images/moslgat.jpg',
        categoryId: '4'),
    CategoryModel(
      categoryName: 'Cheeses',
      categoryImage: 'assets/images/cheese.jpg',
      categoryId: '5',
    ),
    CategoryModel(
        categoryName: 'Sauces',
        categoryImage: 'assets/images/sos.jpg',
        categoryId: '6'),
    CategoryModel(
        categoryName: 'Bakery',
        categoryImage: 'assets/images/bread.jpg',
        categoryId: '7'),
    CategoryModel(
      categoryName: 'Chocolates',
      categoryImage: 'assets/images/choclate.jpg',
      categoryId: '8',
    ),
    CategoryModel(
        categoryName: 'Sweets',
        categoryImage: 'assets/images/halwa.jpeg',
        categoryId: '9'),
    CategoryModel(
        categoryName: 'Nuts',
        categoryImage: 'assets/images/mksrat.gif',
        categoryId: '10'),
    CategoryModel(
        categoryName: 'Grocery',
        categoryImage: 'assets/images/bkala.jpg',
        categoryId: '11'),
  ];

////////////// languag
  bool isEn = true;
  Map<String, Object> textsAr = {
    "landing1": "??????????",
    "landing2": "?????????? ???? ???? ???????? ????????",
    "landing3": "????????",
    "landing4": "?????????? ????????",
    "landing5": "???? ?????????? ??????????????",
    "landing6": "???????????? ??????????",
    "login1": "???????? ????????",
    "login2": "???????????? ????????????????????",
    "login3": "???????? ????????????",
    "login4": "???????? ???????? ????????????",
    "login5": "????????",
    "login6": "???????? ???????????? ?????? ??????????",
    "login7": "???????? ???????????????? ?????? ????????",
    "forgetPass1": "???????? ????????",
    "forgetPass2": "???????????? ????????????????????",
    "forgetPass3": "?????????? ??????????",
    "forgetPass4": "???????? ???????????????? ?????? ????????",
    "forgetPassDialog1": "'???? ?????????? ???????? ?????????? ?????????? ???????? ???????????? ??????????",
    "forgetPassDialog2":
        "?????????? ???????????? ?????? ?????????? ???????????? ?????????????? ???????????????????? ?????????? ?????? ???????????? ?????????? ???????? ???????????? ???????????? ??????",
    "forgetPassDialog3": "??????????",
    "signUp1": "????????",
    "signUp2": "????????????????",
    "signUp3": "????????????",
    "signUp4": "??????",
    "signUp5": "?????????? ???????? ???????????? ?????? ????????",
    "signUp6": "???????? ????????",
    "signUp7": "???????? ???????????????? ?????? ????????",
    "signUp8": "???????? ???????????? ????????????????????",
    "signUp9": "?????? ???????? ?????? ????????",
    "signUp10": "???????? ?????? ??????????",
    "signUp11": "?????????? ?????? ????????",
    "signUp12": "???????? ?????????? ??????????",
    "signUp13": "???????? ???????????? ?????? ??????????",
    "signUp14": "???????? ???????? ????????????",
    "signUp15": "??????????",
    "cart1": "????????????",
    "cart2": "??.??",
    "cart3": "  :  ??????????",
    "cart4": "  :  ?????????? ??????????",
    "cart5": "  :  ????????????",
    "cart6": "???? ?????????? ??????????",
    "cart7": "?????????? ??????????",
    "cart8": "?????????????? ??????????",
    "cart9": "?????? ???????????? ???? ????????????",
    "cart10": " ???? ???????? ?????? ?????? ???????????? ???? ???????????? ",
    "cart11": " ???? ???????? ?????? ?????????? ???????????? ",
    "cart12": "?????????? ????????????",
    "cartEmpty1": "?????? ?????????????????? ??????????",
    "cartEmpty2": "???????? ?????? ???? ?????? ???????????? ???? ?????????????? ?????? ????????",
    "cartEmpty3": "???????? ????????",
    "wishListEmpty1": "?????????????? ??????????",
    "wishListEmpty2": "???????? ?????? ???? ?????? ???????????? ???? ?????????????? ?????? ????????",
    "orderEmpty1": "?????? ?????????????? ??????????",
    "orderEmpty2": "???????? ?????? ???? ?????? ???????????? ???? ?????????? ?????? ????????",
    "feeds": "???????? ????????????????",
    "feedsDia1": "???? ??????????????",
    "feedsDia2": "?????? ??????????????",
    "feedsDia3": "???? ????????????",
    "feedsDia4": "?????? ????????????",
    "feedsDia5": "?????? ????????????",
    "home1": "????????????????",
    "home2": "???????? ???? ????????????",
    "home3": "??????????????",
    "home4": "???????? ????????????????",
    "home5": "??????????",
    "home6": "????????????",
    "home7": "??????????????",
    "home8": "????????????",
    "home9": "??????",
    "home10": "??????????",
    "home11": "??????????????",
    "home12": "????????????????",
    "home13": "????????",
    "home14": "????????????",
    "home15": "??????????",
    "home16": "???????? ??????????",
    "orderDia1": "???? ?????????? ?????????? ??????????",
    "orderDia2":
        "?????? ?????? ?????????????? ???????? ???? ???????? ?????? ???????? ?????????????????? ???????? ?????????? ???? ???????????????? ?????????? ?????????????? ?????????????? ???????? ???????????? ?????????? ???? ?????? ??????????????",
    "orderDia3": "??????????",
    "orderDetails1": "??????????",
    "orderDetails2": "???????????? ??????????",
    "orderDetails3": "???????????? ??????????????",
    "orderDetails4": " : ????????????????",
    "orderDetails5": " : ??????????",
    "orderDetails6": "?????????????? ???????? ???????????? ?????? ????????",
    "orderDetails7": "???????????? ???????? ???? ??????????????",
    "orderDetails8": "?????? ???????????? ???????? ???????????? ?????? ????????",
    "orderDetails9": "?????? ???????? ?????? ??????????????",
    "orderDetails10": "?????????????????? ???????? ??????????",
    "order1": "??????????????",
    "order2": "???????? ?????????? ??????????",
    "productDetails1": "???????????? ????????????",
    "productDetails2": "?????????? ????????????",
    "productDetails3": "???????? ?????????? ?????? ????????",
    "productDetails4": "???? ?????? ???? ????????",
    "productDetails5": "?????? ????????????",
    "productDetails6": "???? ?????????? ????????",
    "productDetails7": "?????????? ????????",
    "productDetails8": "????????????",
    "productReview1": "????????",
    "productReview2": "??????????",
    "productReview3": "??????",
    "productReview4": "???? ????????????",
    "productReview5": "????",
    "productReview6": "???????? ????????????",
    "search1": "??????????",
    "search2": "???????? ???? ????????????",
    "search3": "???? ???????? ??????????",
    "user1": "??????",
    "user2": "?????????? ????????????????",
    "user3": "??????????????",
    "user4": "????????????",
    "user5": "??????????????",
    "user6": "?????????????? ????????????????",
    "user7": "?????? ????????????????",
    "user8": "???????????? ????????????????????",
    "user9": "?????? ????????????",
    "user10": "?????????? ????????????????",
    "user11": "?????????? ????????????????",
    "user12": "??????????????????",
    "user13": "?????????? ????????????",
    "user14": "????????????????????",
    "user15": "?????????? ????????????",
    "user16": "???? ???????? ?????? ?????????? ????????????",
    "dialog": "??????????",
    "wishList1": "??????????????",
    "wishList2": "?????? ???? ??????????????",
    "wishList3": "???? ???????? ?????? ?????? ???????????? ??????????????",
    "backLayer1": "?????????????? ??????",
    "backLayer2": "??????????  ?????????? ?????????? ?????? ???????????? ????????????",
    "backLayer3": "?????????? ??????????????",
    "backLayer4": "????????????",
    "backLayer5": "????????????",
    "backLayer6": "????????????",
    "backLayer7": "??????????????",
    "backLayer8": "???????? ???????? ????????",
    "layout1": "????????????????",
    "layout2": "????????????????",
    "layout3": "??????????",
    "layout4": "????????????",
    "layout5": "????????????????",
    "phone1": "???????????? ????",
    "phone2": "???????? 6 ???????? ??????????????",
    "orderDialog1": "???????????? ??????????",
    "orderDialog2": "?????? ????????????",
    "orderDialog3": "?????????? ????????????",
    "orderDialog4": "?????? ??????????",
    "orderDialog5": "????????????????",
    "orderDialog6": "?????????? ??????????",
    "orderDialog7": "??????????",
    "orderDialog8": "????????????????",
    "orderDialog9": "?????????? ??????????",
    "orderDialog10": "?????????????????? ???????? ??????????",
    "orderDialog11": "???? ???????? ?????? ?????????? ?????? ????????????",
  };
  Map<String, Object> textsEn = {
    "landing1": "Welcome",
    "landing2": "Welcome to kinda cheese",
    "landing3": "Login",
    "landing4": "Sign up",
    "landing5": "Or can use",
    "landing6": "As a gust",
    "login1": "Kinda Cheese",
    "login2": "Email address",
    "login3": "password",
    "login4": "Forget password",
    "login5": "Login",
    "login6": "Invalid password",
    "login7": "Invalid email address",
    "forgetPass1": "Kinda Cheese",
    "forgetPass2": "Email address",
    "forgetPass3": "Reset",
    "forgetPass4": "Invalid email address",
    "forgetPassDialog1": "Password reset link sent successfully",
    "forgetPassDialog2": "Please check your email inbox to reset your password",
    "forgetPassDialog3": "Ok",
    "signUp1": "Choose",
    "signUp2": "Camera",
    "signUp3": "Gallery",
    "signUp4": "Delete",
    "signUp5": "Invalid userName",
    "signUp6": "UserName",
    "signUp7": "Invalid email address",
    "signUp8": "Email address",
    "signUp9": "Invalid phone number",
    "signUp10": "Phone number",
    "signUp11": "Invalid address",
    "signUp12": "Home address",
    "signUp13": "Invalid password",
    "signUp14": "Password",
    "signUp15": "Sign Up",
    "cart1": "Cart",
    "cart2": "P",
    "cart3": "  :  Price",
    "cart4": "  :  Total Price",
    "cart5": "  :  Quantity",
    "cart6": "Order confirmed",
    "cart7": "Confirm order",
    "cart8": "Contact to order",
    "cart9": "Remove from cart",
    "cart10": "Do you want to remove the product from the cart",
    "cart11": " Do you want to remove all products from the cart ",
    "cart12": "Clear cart",
    "cartEmpty1": "Cart is empty",
    "cartEmpty2": "Looks like you haven't added anything to your cart yet",
    "cartEmpty3": "Shopping now",
    "wishListEmpty1": "WishList is empty",
    "wishListEmpty2":
        "Looks like you haven't added anything to your wishList yet",
    "orderEmpty1": "Order is empty",
    "orderEmpty2": "Looks like you haven't added anything to your orders yet",
    "feeds": " All Products",
    "feedsDia1": "In wishList",
    "feedsDia2": "Add to wish",
    "feedsDia3": "In cart",
    "feedsDia4": "Add to cart",
    "feedsDia5": "Open",
    "home1": "Home",
    "home2": "Search the store",
    "home3": "Categories",
    "home4": "Popular products",
    "home5": "Spices",
    "home6": "Freezers",
    "home7": "Drinks",
    "home8": "Ice cream",
    "home9": "Cheeses",
    "home10": "Sauces",
    "home11": "Bakery",
    "home12": "Chocolate",
    "home13": "Sweet",
    "home14": "Nuts",
    "home15": "Grocery",
    "home16": "Watched Recently",
    "orderDia1": "Your request has been successfully confirmed",
    "orderDia2":
        "We will contact you as soon as possible to inquire about the order or products You can call",
    "orderDia3": "ok",
    "orderDetails2": "Order Details",
    "orderDetails3": "Contact Details",
    "orderDetails4": "  :  Total ",
    "orderDetails5": "  :  Shipping",
    "orderDetails6": "The address you entered is not valid",
    "orderDetails7": "more details about the address",
    "orderDetails8": "The phone number you entered is invalid",
    "orderDetails9": "Another phone number to contact",
    "orderDetails10": "Order Inquiry",
    "order1": "Orders",
    "order2": "The order is being delivered",
    "productDetails1": "Product Details",
    "productDetails2": "Product Reviews",
    "productDetails3": "No Reviews yet.",
    "productDetails4": "Be the first to make review",
    "productDetails5": "Add review",
    "productDetails6": "You may also like",
    "productDetails7": "Buy now",
    "productDetails8": "Product",
    "productReview1": "Amazing",
    "productReview2": "Excellent",
    "productReview3": "good",
    "productReview4": "DisLike",
    "productReview5": "Bad",
    "productReview6": "Write your review",
    "search1": "Search",
    "search2": "Search the Store",
    "search3": "No result found",
    "user1": "Gust",
    "user2": "User Bag",
    "user3": "WishList",
    "user4": "Cart",
    "user5": "Order",
    "user6": "User Information",
    "user7": "User Name",
    "user8": "Email address",
    "user9": "Phone number",
    "user10": "User address",
    "user11": "Join date",
    "user12": "Settings",
    "user13": "Dark Theme",
    "user14": "Arabic",
    "user15": "Log out",
    "user16": "Do you really want to log out",
    "dialog": "Cancel",
    "wishList1": "WishList",
    "wishList2": "Remove from wish",
    "wishList3": "Do you want to remove the product from the wishList",
    "backLayer1": "About Us",
    "backLayer2": "Ashmoun filyfal Square behined elhekma pharmacy",
    "backLayer3": "Contacts",
    "backLayer4": "WattsApp",
    "backLayer5": "FaceBook",
    "backLayer6": "Location",
    "backLayer7": "address",
    "backLayer8": "Kinda Cheese Group",
    "layout1": "Home",
    "layout2": "Products",
    "layout3": "Search",
    "layout4": "Cart",
    "layout5": "User",
    "phone1": "Verify",
    "phone2": "Enter 6 digit OTP",
    "orderDialog1": "Order details",
    "orderDialog2": "Customer name",
    "orderDialog3": "Customer address",
    "orderDialog4": "Customer phone",
    "orderDialog5": "Products",
    "orderDialog6": "Total",
    "orderDialog7": "Shipping",
    "orderDialog8": "Total Price",
    "orderDialog9": "Cancel order",
    "orderDialog10": "Inquiries about order",
    "orderDialog11": "Do you want to cancel order",
  };

  void changeLanguage({bool fromShared}) {
    if (fromShared != null) {
      isEn = fromShared;
      emit(StoreAppChangeLanguageState());
    } else {
      isEn = !isEn;
      CacheHelper.putBoolean(key: 'isEn', value: isEn).then((value) {
        emit(StoreAppChangeLanguageState());
      });
    }
  }

  getLan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEn = prefs.getBool("isEn") ?? true;
    emit(StoreAppGetLanguageState());
  }

  Object getTexts(String txt) {
    if (isEn == true) return textsEn[txt];
    return textsAr[txt];
  }

  /////////phone authontication

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
      print(exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber({
    String verificationId,
    String smsCode,
    BuildContext context,
    @required String password,
    @required String name,
    @required String phone,
    @required String address,
    @required String joinedAt,
    @required String createdAt,
    @required String profileImage,
  }) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential).then((value) {
            createUser(
              profileImage: profileImage,
              uId:value.user.uid,
              phone: phone,
              address: address,
              name: name,
              email: '',
              joinedAt: joinedAt,
              createdAt: createdAt,
            );
            getUserData();
            getOrders();
            getWishList();
            getWatchedProducts();
            getCarts();
        showSnackBar(context, "logged In");
        emit(PhoneSignInSuccessState(value.user.uid));
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      emit(PhoneSignInErrorState(e.toString()));
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController mobilePhoneController = TextEditingController();
  String verificationIdFinal = "";
  String smsCode = "";

  void setData(String verificationId) {
    verificationIdFinal = verificationId;
    emit(SetDataState());
  }

  onPinCompleted(pin) {
    print("Completed: " + pin);
    smsCode = pin;
    emit(OnPinCompletedState());
  }
}

//1225192420
