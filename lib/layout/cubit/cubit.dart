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
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/models/wishlist_model.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/feeds_screen/feeds_screen.dart';
import 'package:kinda_store/modules/home_screen/home_screen.dart';
import 'package:kinda_store/modules/landingPage/landing_page.dart';
import 'package:kinda_store/modules/user_screen/user_screen.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
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
    await launch('http://wa.me/01093717500?text=مرحبا بكم في كنده تشيز ');
  }
  ///////////////write comment

  void writeComment({
    @required String dateTime,
    @ required String text,
    @ required String rateDescription,
    @ required double rate,
    @ required String productId,
  }) {
    final commentId = uuid.v4();
    emit(WriteCommentLoadingState());
    CommentModel model = CommentModel(
      userId: uId,
      imageUrl: profileImage??"https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png",
      dateTime: dateTime,
      productId: productId,
      rate: rate??3,
      rateDescription: rateDescription??'جيد',
      commentId: commentId,
      username: name??"زائر",
      text: text,
    );
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('comments')
        .add(model.toMap())
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
        .collection('products').doc(productId).collection('comments').
        get()
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
  double rate ;
  String rateDescription;
  void changeRating(rating) {
    rate=rating;
    if (rating > 0 && rating <= 1){
      rateDescription ='سئ';
    }
    else if (rating > 1 && rating <= 2){
      rateDescription ='لم يعجبني';
    }
    else if (rating > 2 && rating <=3){
      rateDescription ='جيد';
    }
    else if (rating > 3 && rating <= 4){
      rateDescription ='ممتاز';
    }
    else if (rating > 4 && rating <= 5){
      rateDescription ='رائع';
    }
    else{
      rate =3.0;
      rateDescription="جيد";
    }
    print(rating);
   // emit(ChangeRateSuccessStates());
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
        .child('users/${Uri
        .file(profile.path)
        .pathSegments
        .last}')
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
      name = StoreAppCubit.get(context).isEn ?'Gust':'زائر';
      email = StoreAppCubit.get(context).isEn ?'Without email address':'بدون بريد الكتروني';
      joinedAt = formattedDate;
      phone = StoreAppCubit.get(context).isEn ?'Without phone number':'بدون رقم هاتف';
      address = StoreAppCubit.get(context).isEn ?'Without address':'بدون عنوان';
      profileImage =
      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
      createdAt = Timestamp.now().toString();
      getUserData();
      getOrders();
      getWishList();
      getCarts();
      navigateTo(context, StoreLayout());
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
          getOrders();
          navigateTo(context, StoreLayout());
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
            price: element.get('price'),
            imageUrl: element.get('imageUrl'),
            userId: element.get('userId'),
            userAddress: element.get('userAddress'),
            total: element.get('total'),
            subTotal: element.get('subTotal'),
            anotherNumber: element.get('anotherNumber'),
            addressDetails: element.get('addressDetails'),
            quantity: element.get('quantity'),
            productId: element.get('productId'),
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
          builder: (context) =>
              AlertDialog(
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
        .where((element) =>
        element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }
  List<Product> findByCategoryEn(String categoryName) {
    List categoryList = products
        .where((element) =>
        element.productCategoryNameEn
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  var uuid = Uuid();

  void addItemToCart({
    String productId,
    String title,
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
            userId: element.get('userId'),
          ),
        );
      });
      emit(GetCartsSuccessStates());
    }).catchError((error) {
      emit(GetCartsErrorStates(error.toString()));
    });
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
  void addItemByOne({String productId,
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

  void reduceItemByOne({String productId,
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

//////////////////

  //////////////////////WishList
  void addToWishList({
    String productId,
    String title,
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
              price: double.parse(
                element.get('price'),
              ),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              productCategoryNameEn: element.get('productCategoryNameُEn'),
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
  void signOut(context) =>
      CacheHelper.removeData(key: 'uId').then((value) {
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
        categoryName: 'توابل', categoryImage: 'assets/images/twabl.jpg',categoryId: '1'),
    CategoryModel(
        categoryName: 'مجمدات', categoryImage: 'assets/images/mogmdat.jpg',categoryId: '2'),
    CategoryModel(
        categoryName: 'مشروبات', categoryImage: 'assets/images/mshrob.jpg',categoryId: '3'),
    CategoryModel(
        categoryName: 'مثلجات', categoryImage: 'assets/images/moslgat.jpg',categoryId: '4'),
    CategoryModel(
      categoryName: 'جبن',
      categoryImage: 'assets/images/cheese.jpg',categoryId: '5',
    ),
    CategoryModel(
        categoryName: 'صوصات', categoryImage: 'assets/images/sos.jpg',categoryId: '6'),
    CategoryModel(
        categoryName: 'مخبوزات', categoryImage: 'assets/images/bread.jpg',categoryId: '7'),
    CategoryModel(
      categoryName: 'شيكولاته',categoryId: '8',
      categoryImage: 'assets/images/choclate.jpg',
    ),
    CategoryModel(
        categoryName: 'حلوي', categoryImage: 'assets/images/halwa.jpeg',categoryId: '9'),
    CategoryModel(
        categoryName: 'مكسرات', categoryImage: 'assets/images/mksrat.gif',categoryId: '10'),
    CategoryModel(
        categoryName: 'بقاله', categoryImage: 'assets/images/bkala.jpg',categoryId: '11'),
  ];
  List<CategoryModel> categoriesEng = [
    CategoryModel(
        categoryName: 'Spices', categoryImage: 'assets/images/twabl.jpg',categoryId: '1'),
    CategoryModel(
        categoryName: 'Freezers', categoryImage: 'assets/images/mogmdat.jpg',categoryId: '2'),
    CategoryModel(
        categoryName: 'Drinks', categoryImage: 'assets/images/mshrob.jpg',categoryId: '3'),
    CategoryModel(
        categoryName: 'Ice cream', categoryImage: 'assets/images/moslgat.jpg',categoryId: '4'),
    CategoryModel(
      categoryName: 'Cheeses',
      categoryImage: 'assets/images/cheese.jpg',categoryId:'5',
    ),
    CategoryModel(
        categoryName: 'Sauces', categoryImage: 'assets/images/sos.jpg',categoryId: '6'),
    CategoryModel(
        categoryName: 'Bakery', categoryImage: 'assets/images/bread.jpg',categoryId: '7'),
    CategoryModel(
      categoryName: 'Chocolates',
      categoryImage: 'assets/images/choclate.jpg',categoryId: '8',
    ),
    CategoryModel(
        categoryName: 'Sweets', categoryImage: 'assets/images/halwa.jpeg',categoryId: '9'),
    CategoryModel(
        categoryName: 'Nuts', categoryImage: 'assets/images/mksrat.gif',categoryId: '10'),
    CategoryModel(
        categoryName: 'Grocery', categoryImage: 'assets/images/bkala.jpg',categoryId: '11'),
  ];

////////////// languag
  bool isEn = true;
  Map<String, Object> textsAr = {
    "landing1": "مرحبا",
    "landing2": "مرحبا بك في كنده تشيز",
    "landing3": "دخول",
    "landing4": "انشاء حساب",
    "landing5": "او يمكنك استخدام",
    "landing6": "الدخول كزائر",
    "login1": "كنده تشيز",
    "login2": "البريد الالكتروني",
    "login3": "كلمه المرور",
    "login4": "نسيت كلمه المرور",
    "login5": "دخول",
    "login6": "كلمه المرور غير صالحه",
    "login7": "بريد الكتروني غير صالح",
    "forgetPass1": "كنده تشيز",
    "forgetPass2": "البريد الالكتروني",
    "forgetPass3": "اعاده تعيين",
    "forgetPass4": "بريد الكتروني غير صالح",
    "forgetPassDialog1": "'تم ارسال رابط اعاده تعيين كلمه المرور بنجاح",
    "forgetPassDialog2": "برجاء التوجه الي صندوق الوارد بالبريد الالكتروني الخاص بكم لاعاده تعيين كلمه المرور الخاصه بكم",
    "forgetPassDialog3": "موافق",
    "signUp1": "اختر",
    "signUp2": "الكاميرا",
    "signUp3": "المعرض",
    "signUp4": "حذف",
    "signUp5": "الاسم الذي ادخلته غير صالح",
    "signUp6": "ادخل اسمك",
    "signUp7": "بريد الكتروني غير صالح",
    "signUp8": "ادخل البريد الالكتروني",
    "signUp9": "رقم هاتف غير صالح",
    "signUp10": "ادخل رقم هاتفك",
    "signUp11": "عنوان غير صالح",
    "signUp12": "اكتب عنوان منزلك",
    "signUp13": "كلمه المرور غير صالحه",
    "signUp14": "ادخل كلمه المرور",
    "signUp15": "تسجيل",
    "cart1": "العربه",
    "cart2": "ج.م",
    "cart3": "  :  السعر",
    "cart4": "  :  السعر الكلي",
    "cart5": "  :  الكميه",
    "cart6": "تم تأكيد الطلب",
    "cart7": "تأكيد الطلب",
    "cart8": "الاتصال للطلب",
    "cart9": "حذف المنتج من العربه",
    "cart10": " هل تريد حقل حذف المنتج من العربه ",
    "cartEmpty1": "سله المشتريات فارغه",
    "cartEmpty2": "يبدو انك لم تقم باضافه اي مشتريات حتي الان",
    "cartEmpty3": "تسوق الان",
    "wishListEmpty1": "المفضله فارغه",
    "wishListEmpty2": "يبدو انك لم تقم باضافه اي تفضيلات حتي الان",
    "orderEmpty1": "سله الطلبات فارغه",
    "orderEmpty2": "يبدو انك لم تقم باضافه اي طلبات حتي الان",
    "feeds": "جميع المنتجات",
    "feedsDia1": "في المفضلة",
    "feedsDia2": "اضف للمفضلة",
    "feedsDia3": "في العربه",
    "feedsDia4": "اضف للعربه",
    "feedsDia5": "فتح المنتج",
    "home1": "الرئيسية",
    "home2": "ابحث في المتجر",
    "home3": "الاصناف",
    "home4": "اشهر المنتجات",
    "home5": "توابل",
    "home6": "مجمدات",
    "home7": "مشروبات",
    "home8": "مثلجات",
    "home9": "جبن",
    "home10": "صوصات",
    "home11": "مخبوزات",
    "home12": "شيكولاته",
    "home13": "حلوي",
    "home14": "مكسرات",
    "home15": "بقاله",
    "home16": "شوهد موخرا",
    "orderDia1": "تم تاكيد طلبكم بنجاح",
    "orderDia2": "سوف يتم التواصل معكم في اقرب وقت ممكن للاستفسار بشان الطلب او المنتجات يمكنك الاتصال",
    "orderDia3": "موافق",
    "orderDetails1": "موافق",
    "orderDetails2": "تفاصيل الطلب",
    "orderDetails3": "تفاصيل التواصل",
    "orderDetails4": "الاجمالي",
    "orderDetails5": "الشحن",
    "orderDetails6": "العنوان الذي ادخلته غير صالح",
    "orderDetails7": "تفاصيل اكثر عن العنوان",
    "orderDetails8": "رقم الهاتف الذي ادخلته غير صالح",
    "orderDetails9": "رقم هاتف اخر للتواصل",
    "orderDetails10": "الاستفسار بشأن الطلب",
    "order1": "الطلبات",
    "order2": "جاري توصيل الطلب",
    "productDetails1": "تفاصيل المنتج",
    "productDetails2": "تقييم المنتج",
    "productDetails3": "بدون تقييم حتي الان",
    "productDetails4": "كن اول من يقيم",
    "productDetails5": "اضف تقييمك",
    "productDetails6": "قد يعجبك ايضا",
    "productDetails7": "اشتري الان",
    "productDetails8": "منتج",
    "productReview1": "رائع",
    "productReview2": "ممتاز",
    "productReview3": "جيد",
    "productReview4": "لم يعجبني",
    "productReview5": "سئ",
    "productReview6": "اكتب تقييمك",
    "search1": "البحث",
    "search2": "ابحث في المتجر",
    "search3": "لا توجد نتائج",
    "user1": "ضيف",
    "user2": "حقيبه المستخدم",
    "user3": "المفضله",
    "user4": "العربه",
    "user5": "الطلبات",
    "user6": "معلومات المستخدم",
    "user7": "اسم المستخدم",
    "user8": "البريد الالكتروني",
    "user9": "رقم الهاتف",
    "user10": "عنوان المستخدم",
    "user11": "تاريخ الانضمام",
    "user12": "الاعدادات",
    "user13": "الوضع الليلي",
    "user14": "الانجليزيه",
    "user15": "تسجيل الخروج",
    "user16": "هل تريد حقا تسجيل الخروج",
    "dialog": "الغاء",
    "wishList1": "المفضله",
    "wishList2": "حذف من المفضله",
    "wishList3": "هل تريد حقا حذف المنتج المفضله",
    "backLayer1": "معلومات عنا",
    "backLayer2": "اشمون  ميدان فليفل خلف صيدليه الحكمه",
    "backLayer3": "ارقام التواصل",
    "backLayer4": "واتساب",
    "backLayer5": "فيسبوك",
    "backLayer6": "الموقع",
    "backLayer7": "العنوان",
    "layout1": "الرئيسيه",
    "layout2": "المنتجات",
    "layout3": "البحث",
    "layout4": "العربه",
    "layout5": "المستخدم",
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
    "login4": "Forget password ?",
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
    "cart9" : "Remove from cart",
    "cart10": "Do you want to remove the product from the cart",
    "cartEmpty1": "Cart is empty",
    "cartEmpty2": "Looks like you haven't added anything to your cart yet",
    "cartEmpty3": "Shopping now",
    "wishListEmpty1": "WishList is empty",
    "wishListEmpty2": "Looks like you haven't added anything to your wishList yet",
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
    "orderDia2": "We will contact you as soon as possible to inquire about the order or products You can call",
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
    "layout1": "Home",
    "layout2": "Products",
    "layout3": "Search",
    "layout4": "Cart",
    "layout5": "User",
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
  getLan() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEn = prefs.getBool("isEn")?? true;
    emit(StoreAppGetLanguageState());
  }
  Object getTexts(String txt) {
    if (isEn == true) return textsEn[txt];
    return textsAr[txt];
  }
}