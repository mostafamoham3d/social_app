abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginFailedState extends LoginStates {
  String error;
  LoginFailedState(this.error);
}

class LoginShowPassState extends LoginStates {}

class LoginHidePassState extends LoginStates {}
