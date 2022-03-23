import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/cubit/login_cubit.dart';
import 'package:social_app/cubit/login_states.dart';
import 'package:social_app/screens/layout_screen.dart';
import 'package:social_app/screens/sign_up_screen.dart';

class LogInScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, states) {
          if (states is LoginFailedState) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: states.error,
            );
          }
          if (states is LoginSuccessState) {
            print('done1');
            print(uId);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => SocialLayoutScreen()));
          }
        },
        builder: (context, states) {
          LoginCubit cubit = LoginCubit.get(context);
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
                      Text('Welcome back!',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 30,
                                  )),
                      Text(
                        'Log in to your existing account',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 10,
                            ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
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
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color),
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
                            cubit.login(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            //textAlign: TextAlign.end,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.login(
                                context: context,
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
                            child: states is LoginLoadingState
                                ? CircularProgressIndicator()
                                : Text(
                                    'LOG IN',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dont have an account?',
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
                                      builder: (ctx) => SignUpScreen()));
                            },
                            child: Text(
                              'Sign up ',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
