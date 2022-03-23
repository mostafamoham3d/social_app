import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/cubit/sign_up_states.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/helpers/shared_prefs.dart';
import 'package:social_app/models/auth_user_model.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);
  var iconData = Icon(Icons.visibility);
  bool isObSecure = true;

  void changePassState() {
    isObSecure = !isObSecure;
    iconData = isObSecure ? Icon(Icons.visibility) : Icon(Icons.visibility_off);
    emit(SignUpShowPassState());
  }

  void signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required context,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      var model = AuthUserModel(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
        image:
            'https://image.freepik.com/free-photo/pleased-adorable-blonde-middle-aged-woman-holds-smartphone-uses-mobile-phone_273609-45739.jpg',
        cover:
            'https://image.freepik.com/free-photo/young-man-with-toothache-seeking-medical-stomatologist-health-advice_482257-2359.jpg',
        bio: 'write your bio...',
      );
      SharedPrefs.setData(key: 'uId', value: value.user!.uid);
      uId = SharedPrefs.getData('uId');
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(model.toMap())
          .then((value) {
        SocialCubit.get(context).getUser();
        SocialCubit.get(context).currentIndex = 0;
        emit(SignUpUploadUserDataSuccess());
      }).catchError((error) {
        emit(SignUpUploadUserDataError());
      });
    }).catchError((error) {
      emit(SignUpFailedState(error.toString()));
    });
  }
}
