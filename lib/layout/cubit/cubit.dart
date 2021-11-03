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
import 'package:kinda_store/models/user_model.dart';
import 'package:kinda_store/modules/search/search_screen.dart';
import 'package:kinda_store/modules/sign_up_screen/cubit/states.dart';
import 'package:kinda_store/shared/components/components.dart';
import 'package:kinda_store/layout/cubit/states.dart';
import 'package:kinda_store/models/cart_model.dart';
import 'package:kinda_store/models/category_model.dart';
import 'package:kinda_store/models/order_model.dart';
import 'package:kinda_store/models/product_model.dart';
import 'package:kinda_store/models/wishlist_model.dart';
import 'package:kinda_store/modules/cart_screen/cart_screen.dart';
import 'package:kinda_store/modules/categories_screen/categoties_feed_screen.dart';
import 'package:kinda_store/modules/feeds_screen/feeds_screen.dart';
import 'package:kinda_store/modules/home_screen/home_screen.dart';
import 'package:kinda_store/modules/landingPage/landing_page.dart';
import 'package:kinda_store/modules/user_screen/user_screen.dart';
import 'package:kinda_store/shared/network/local/cache_helper.dart';
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

  void openWattsAppChat () async {
    await launch('http://wa.me/01093717500?text=مرحبا بكم في كنده تشيز ');
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
        .createUserWithEmailAndPassword(email: email, password: password,)
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
        url=value;
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
    url = 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
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
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse
        .year}";
    FirebaseAuth.instance
        .signInAnonymously()
        .then((value) {
      name = 'زائر';
      email = 'بدون بريد الكتروني';
      joinedAt = formattedDate;
      phone = 'بدون رقم هاتف' ;
      address = 'بدون عنوان';
      profileImage ='https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
      createdAt =  Timestamp.now().toString();
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update({
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
  String phone ;
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
      createdAt =  userDoc.get('createdAt');
      emit(GetUserLoginSuccessStates());
    }
  }
  Future<void> googleSignIn(context) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse
        .year}";
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
          createdAt = Timestamp.now().toString() ;
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
            imageUrl: element.get('imageUrl'),),
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
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse
        .year}";
    loading = true;
    emit(LoginWithFacebookLoadingStates());
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value){
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
        CacheHelper.saveData(key: 'uId', value: value.user.uid ).then((value) {
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

      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Log in with facebook failed'),
        content: Text(content),
        actions: [TextButton(onPressed: () {
          Navigator.of(context).pop();

        }, child: Text('Ok'))],
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
              isPopular: true),
        );
      });
      emit(GetProductSuccessStates());
    }).catchError((error) {
      emit(GetProductErrorStates());
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
    CategoryModel(categoryName: 'توابل', categoryImage: 'assets/images/twabl.jpg'),
    CategoryModel(categoryName: 'مجمدات', categoryImage: 'assets/images/mogmdat.jpg'),
    CategoryModel(categoryName: 'مشروبات', categoryImage: 'assets/images/mshrob.jpg'),
    CategoryModel(categoryName: 'مثلجات', categoryImage: 'assets/images/moslgat.jpg'),
    CategoryModel(categoryName: 'جبن', categoryImage: 'assets/images/cheese.jpg',),
    CategoryModel(categoryName: 'صوصات', categoryImage: 'assets/images/sos.jpg'),
    CategoryModel(categoryName: 'مخبوزات', categoryImage: 'assets/images/bread.jpg'),
    CategoryModel(categoryName: 'شيكولاته', categoryImage: 'assets/images/choclate.jpg',),
    CategoryModel(categoryName: 'حلوي', categoryImage: 'assets/images/halwa.jpeg'),
    CategoryModel(categoryName: 'مكسرات', categoryImage: 'assets/images/mksrat.gif'),
    CategoryModel(categoryName: 'بقاله', categoryImage: 'assets/images/bkala.jpg'),
  ];

  Widget buildCategoryItem(context, CategoryModel category) => InkWell(
        onTap: () {
          navigateTo(
              context,
              CategoriesFeedScreen(
                categoryName: category.categoryName,
              ));
        },
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xff37475A).withOpacity(0.2),
                blurRadius: 20.0,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image(
                image: AssetImage(
                  category.categoryImage,
                ),
                fit: BoxFit.fill,
                height: 150,
                width: 150,
              ),
              Container(
                  height: 30,
                  width: 150,
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Text(
                      category.categoryName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      );

// BrandScreen
}
