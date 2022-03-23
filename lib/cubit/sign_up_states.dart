abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {}

class SignUpFailedState extends SignUpStates {
  String error;
  SignUpFailedState(this.error);
}

class SignUpUploadUserDataSuccess extends SignUpStates {}

class SignUpUploadUserDataError extends SignUpStates {}

class SignUpShowPassState extends SignUpStates {}

class SignUpHidePassState extends SignUpStates {}
