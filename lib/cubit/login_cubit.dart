import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/cubit/login_states.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/helpers/shared_prefs.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  var iconData = Icon(Icons.visibility);
  bool isObSecure = true;
  void changePassState() {
    isObSecure = !isObSecure;
    iconData = isObSecure ? Icon(Icons.visibility) : Icon(Icons.visibility_off);
    emit(LoginShowPassState());
  }

  void login({
    required String email,
    required String password,
    required context,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      SharedPrefs.setData(key: 'uId', value: value.user!.uid);
      uId = value.user!.uid;
      SocialCubit.get(context).getUser();
      SocialCubit.get(context).getPosts();
      SocialCubit.get(context).currentIndex = 0;
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginFailedState(error.toString()));
    });
  }
}
