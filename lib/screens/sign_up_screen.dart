import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/sign_up_cubit.dart';
import 'package:social_app/cubit/sign_up_states.dart';
import 'package:social_app/screens/sign_in_screen.dart';

import 'layout_screen.dart';

class SignUpScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SignUpFailedState) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: state.error,
            );
          }
          if (state is SignUpUploadUserDataSuccess) {
            print('done');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => SocialLayoutScreen()));
          }
        },
        builder: (context, state) {
          var cubit = SignUpCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          height: 200,
                          child: Image.asset('assets/images/sign_in.jpg'),
                        ),
                      ),
                      Text(
                        'SIGN UP!',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 30,
                            ),
                      ),
                      Text(
                        'Create your new account',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 10,
                            ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
                          hintText: 'Name',
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Your name Can\'t empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
                          hintText: 'Phone No.',
                          prefixIcon: Icon(Icons.phone),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Phone number Can\'t empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
                          hintText: 'Email Address',
                          prefixIcon: Icon(Icons.mail),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Email Can\'t empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: passwordController,
                        obscureText: cubit.isObSecure,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          suffixIcon: IconButton(
                            icon: cubit.iconData,
                            onPressed: () {
                              cubit.changePassState();
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password Can\'t empty';
                          }
                        },
                        onFieldSubmitted: (val) {
                          if (formKey.currentState!.validate()) {
                            cubit.signUp(
                                context: context,
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.signUp(
                                context: context,
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF2D46B9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: state is SignUpLoadingState
                                ? CircularProgressIndicator()
                                : Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) => LogInScreen()));
                            },
                            child: Text(
                              'Sign in ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
