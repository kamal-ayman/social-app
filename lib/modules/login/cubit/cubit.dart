import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(AppInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required email,
    required password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      toastShow(text: 'Sign in Successfully', state: ToastStates.SUCCESS);
      uId = value.user!.uid;
      CacheHelper.saveData(key: 'uId', value: uId);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error));
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

}
