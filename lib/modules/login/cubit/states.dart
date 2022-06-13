abstract class LoginStates {}

class AppInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final error;

  LoginErrorState(this.error);
}

class SwitchPassInputState extends LoginStates {}

class SwitchRememberCheckBoxState extends LoginStates {}

class CheckReadyEmailState extends LoginStates {}

class CheckReadyPhoneState extends LoginStates {}
