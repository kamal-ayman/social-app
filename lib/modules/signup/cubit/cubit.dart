// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/signup/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';

class SignupCubit extends Cubit<SignupStates> {
  SignupCubit() : super(AppInitialState());

  static SignupCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required name,
    required email,
    required password,
    required phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(phone: phone, email: email, name: name, uid: value.user!.uid);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required name,
    required email,
    required phone,
    required uid,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uid,
      isEmailVerified: false,
      image:
          'https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?t=st=1650921798~exp=1650922398~hmac=ef2848e3ae8795a5ae76d035941797b2a379c1c48800d394e7c733793c758059&w=996',
      cover:
          'https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?t=st=1650921798~exp=1650922398~hmac=ef2848e3ae8795a5ae76d035941797b2a379c1c48800d394e7c733793c758059&w=996',
      bio: 'hi, i\'m using this app',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      toastShow(text: 'Sign up Successfully', state: ToastStates.SUCCESS);
      uId = uid;
      CacheHelper.saveData(key: 'uId', value: uId);
      emit(CreateUserSuccessState(uid));
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error));
    });
  }

  IconData icon = Icons.remove_red_eye_outlined;
  bool password = true;

  void switchIcon() {
    password = !password;
    !password
        ? icon = Icons.remove_red_eye_rounded
        : icon = Icons.remove_red_eye_outlined;
    emit(SwitchPassInputState());
  }

  var isNameReady = false;

  void checkReadyName(String? name) {
    if (name!.length > 4)
      isNameReady = true;
    else
      isNameReady = false;
    emit(CheckReadyNameState());
  }

  var isEmailReady = false;
  var lengthOfEmail = 0;

  void checkReadyEmail(String? value) {
    String pattern = "[a-zA-Z0-9.]+@[a-zA-Z0-9]+.com";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      isEmailReady = false;
    } else {
      isEmailReady = true;
    }
    emit(CheckReadyEmailState());
  }

  var isPhoneReady = false;

  void checkReadyPhone(String? value) {
    String pattern = '^[0][1][0-9]\\d{8}\$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      isPhoneReady = false;
    } else {
      isPhoneReady = true;
    }
    emit(CheckReadyPhoneState());
  }

  var isPassReady = false;
  String passwordConfirm = "";
  String passwordConfirmAgain = "";

  void checkReadyPassConfirm(String? pass) {
    passwordConfirm = pass!;
    checkPasswordConfirm();
  }

  void checkReadyPassConfirmAgain(String? pass) {
    passwordConfirmAgain = pass!;
    checkPasswordConfirm();
  }

  void checkPasswordConfirm() {
    if (passwordConfirm.length >= 6 && passwordConfirm == passwordConfirmAgain)
      isPassReady = true;
    else
      isPassReady = false;
    emit(CheckReadyPassState());
  }
}
