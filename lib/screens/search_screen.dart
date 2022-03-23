import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/auth_user_model.dart';
import 'package:social_app/styles/icon_broken.dart';

import 'chatting_screen.dart';

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  final searchController1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).searchedUsers = [];
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Search User'),
            titleSpacing: 5,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    print(value);

                    cubit.getSearchedUsers(value);
                  },
                  onFieldSubmitted: (value) {
                    cubit.getSearchedUsers(value);
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color),
                    prefixIcon: Icon(IconBroken.User),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'User name Can\'t empty';
                    }
                  },
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return buildChatItem(
                            cubit.searchedUsers[index], context);
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[300],
                          padding: EdgeInsets.symmetric(vertical: 10),
                        );
                      },
                      itemCount: cubit.searchedUsers.length),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildChatItem(AuthUserModel model, context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => ChattingScreen(model)));
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
