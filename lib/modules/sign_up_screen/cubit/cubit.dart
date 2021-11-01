import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/store_layout.dart';
import 'package:kinda_store/models/user_model.dart';
import 'package:kinda_store/modules/sign_up_screen/cubit/states.dart';
import 'package:kinda_store/shared/components/components.dart';


class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);


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

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(SignUpPasswordVisibilityState());
  }
  File profileImage;
  String url;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
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
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadPickedProfileImageSuccessState());
        url=value;
        print(value);
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
    final pickedImageFile = File(pickedImage.path);
    profileImage = pickedImageFile;
    uploadProfileImage();
    emit(SignUpPickedProfileImageCameraSuccessState());
  }

  void remove() {
    url = 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
    uploadProfileImage();
emit(SignUpRemoveProfileImageSuccessState());
  }
}
