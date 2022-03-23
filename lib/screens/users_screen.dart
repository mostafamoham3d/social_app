import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/auth_user_model.dart';
import 'package:social_app/screens/user_details_screen.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUsers();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context).usersList;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return buildChatItem(cubit[index], context);
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[300],
                              padding: EdgeInsets.symmetric(vertical: 10),
                            );
                          },
                          itemCount: cubit.length),
                    )
                  ],
                ),
              ),
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
      SocialCubit.get(context).getUsersPosts(model.uId);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UserDetailsScreen(model)));
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
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          '100',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          'Following',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          '100',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
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
