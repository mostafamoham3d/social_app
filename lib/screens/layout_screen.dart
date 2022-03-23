import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/screens/post_screen.dart';
import 'package:social_app/screens/search_screen.dart';
import 'package:social_app/styles/icon_broken.dart';

class SocialLayoutScreen extends StatelessWidget {
  final List<IconData> iconData = [
    IconBroken.Home,
    IconBroken.Chat,
    IconBroken.User,
    IconBroken.Setting,
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('${cubit.appBarTitle[cubit.currentIndex]}'),
            actions: [
              if (cubit.currentIndex == 3)
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).changeTheme();
                  },
                  icon: AppCubit.get(context).isDark
                      ? Icon(Icons.wb_sunny)
                      : Icon(Icons.brightness_2_sharp),
                  color: Theme.of(context).iconTheme.color,
                ),
              if (cubit.currentIndex == 3)
                IconButton(
                  onPressed: () {
                    cubit.logOut(context);
                  },
                  icon: Icon(Icons.login_outlined),
                ),
              if (cubit.currentIndex != 3)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(IconBroken.Notification),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                      },
                      icon: Icon(IconBroken.Search),
                    ),
                  ],
                )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => PostScreen()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: iconData,
            activeColor: Colors.blue,
            inactiveColor: Colors.black,
            activeIndex: cubit.currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) {
              cubit.changeScreen(index);
            },
            //other params
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
