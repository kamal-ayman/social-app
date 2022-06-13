abstract class SignupStates {}

class AppInitialState extends SignupStates {}

class SwitchPassInputState extends SignupStates {}

class RegisterLoadingState extends SignupStates {}

class RegisterSuccessState extends SignupStates {}

class RegisterErrorState extends SignupStates {
  final error;

  RegisterErrorState(this.error);
}

class CreateUserSuccessState extends SignupStates {
  final String uId;

  CreateUserSuccessState(this.uId);
}

class CreateUserErrorState extends SignupStates {
  final error;

  CreateUserErrorState(this.error);
}

class SwitchRememberCheckBoxState extends SignupStates {}

class CheckReadyNameState extends SignupStates {}

class CheckReadyEmailState extends SignupStates {}

class CheckReadyPhoneState extends SignupStates {}

class CheckReadyPassState extends SignupStates {}
