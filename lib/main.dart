import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/cubit/app_states.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/helpers/shared_prefs.dart';
import 'package:social_app/screens/layout_screen.dart';
import 'package:social_app/screens/sign_in_screen.dart';

import 'cubit/app_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.init();
  Widget startScreen = LogInScreen();
  uId = SharedPrefs.getData('uId') ?? null;
  print(uId);
  if (uId != null) {
    startScreen = SocialLayoutScreen();
  } else {
    startScreen = LogInScreen();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  MyApp(this.startScreen);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()
              ..getUser()
              ..getUsers()
              ..getPosts()),
        BlocProvider(create: (context) => AppCubit())
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            home: startScreen,
            theme: ThemeData(
              fontFamily: 'Jannah',
              textTheme: TextTheme(
                bodyText1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                bodyText2: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                backwardsCompatibility: false,
                backgroundColor: Colors.white,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jannah'),
              ),
              accentIconTheme: IconThemeData(
                color: Colors.white,
              ),
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blue,
                elevation: 20,
              ),
            ),
            darkTheme: ThemeData(
              fontFamily: 'Jannah',
              scaffoldBackgroundColor: Color(0xFF444444),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              accentColor: Colors.white,
              appBarTheme: AppBarTheme(
                backwardsCompatibility: false,
                backgroundColor: Color(0xFF444444),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF444444),
                  statusBarIconBrightness: Brightness.light,
                ),
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jannah'),
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                bodyText2: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                caption: TextStyle(color: Colors.white),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (state) => Colors.black),
                ),
              ),
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color(0xFF444444),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                elevation: 20,
              ),
              cardColor: Color(0xFF393E46),
            ),
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
