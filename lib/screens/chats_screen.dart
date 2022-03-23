import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/auth_user_model.dart';
import 'package:social_app/screens/chatting_screen.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // if (SocialCubit.get(context).chattedWithUsersIds != null) {
        //   SocialCubit.get(context).getChattedWithUsers();
        // }
        // print(SocialCubit.get(context).authUserModel!.uId);
        SocialCubit.get(context).getUsers();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              body: cubit.usersList.length > 0
                  ? ListView.builder(
                      itemCount: cubit.usersList.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            buildChatItem(cubit.usersList[index], context),
                            Container(
                              height: 1,
                              color: Colors.grey,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ],
                        );
                      })
                  : Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}

Widget buildChatItem(AuthUserModel model, context) {
  return InkWell(
    onTap: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => ChattingScreen(model)));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${model.name}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(height: 1.3),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (FirebaseAuth.instance.currentUser!.emailVerified)
                      Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 15,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
