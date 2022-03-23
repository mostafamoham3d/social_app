import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/screens/edit_profile_screen.dart';
import 'package:social_app/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context)
            .getUsersPosts(SocialCubit.get(context).authUserModel!.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 190,
                      child: Stack(
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${cubit.authUserModel!.cover}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).appBarTheme.color,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  '${cubit.authUserModel!.image}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${cubit.authUserModel!.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${cubit.authUserModel!.bio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
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
                          ),
                          Expanded(
                            child: Column(
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
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Add Photos',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => EditProfileScreen(),
                              ),
                            );
                          },
                          child: Icon(
                            IconBroken.Edit,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (cubit.usersPost.length > 0)
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return buildUserPostItem(
                                  context, cubit.usersPost[index], index);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: cubit.usersPost.length),
                      ),
                    if (cubit.usersPost.length < 0)
                      Center(
                        child: Text(
                          'No Posts',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
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

Widget buildUserPostItem(context, PostModel model, index) {
  TextEditingController commentController = TextEditingController();
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5,
    margin: EdgeInsets.symmetric(horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    Text(
                      '${model.date}',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          Text(
            '${model.text}',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  height: 1.1,
                ),
          ),
          SizedBox(
            height: 15,
          ),
          if (model.postImage != '')
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                image: DecorationImage(
                  image: NetworkImage(
                    '${model.postImage}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context)
                              .likePost(SocialCubit.get(context).postId[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${SocialCubit.get(context).likesOfUsers[index] ?? '0'}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            IconBroken.Chat,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${SocialCubit.get(context).commentOfUsers[index]}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      InkWell(
                        onTap: () async {
                          await SocialCubit.get(context).getUserComentat(
                              SocialCubit.get(context).usersPostId[index]);
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                //this right here
                                child: Container(
                                  color: Theme.of(context).cardColor,
                                  height: 300.0,
                                  width: 300.0,
                                  child: SocialCubit.get(context)
                                              .comentatOfUsers
                                              .length >
                                          0
                                      ? ListView.separated(
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.all(20),
                                              child: Center(
                                                child: Text(
                                                  '${SocialCubit.get(context).comentatOfUsers[index]}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Container(
                                              width: double.infinity,
                                              height: 1,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              color: Colors.grey[300],
                                            );
                                          },
                                          itemCount: SocialCubit.get(context)
                                              .comentatOfUsers
                                              .length)
                                      : Center(
                                          child: Text(
                                          'No comments',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        )),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Comments',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          // Row(
          //   children: [
          //     CircleAvatar(
          //       backgroundImage: NetworkImage(
          //           '${SocialCubit.get(context).authUserModel!.image}'),
          //       radius: 20,
          //     ),
          //     SizedBox(
          //       width: 8,
          //     ),
          //     Expanded(
          //         child: TextFormField(
          //           onFieldSubmitted: (value) {
          //             SocialCubit.get(context).commentToPost(
          //                 postId: SocialCubit.get(context).postId[index],
          //                 comment: commentController.text);
          //           },
          //           controller: commentController,
          //           style: Theme.of(context)
          //               .textTheme
          //               .bodyText2!
          //               .copyWith(fontSize: 14),
          //           decoration: InputDecoration(
          //               hintText: 'Write a comment...',
          //               hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
          //                 fontSize: 12,
          //               )),
          //         )),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Expanded(
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 InkWell(
          //                   onTap: () {
          //                     SocialCubit.get(context).likePost(
          //                         SocialCubit.get(context).postId[index]);
          //                   },
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(5.0),
          //                     child: Icon(
          //                       IconBroken.Heart,
          //                       color: Colors.red,
          //                       size: 20,
          //                     ),
          //                   ),
          //                 ),
          //                 Text(
          //                   'Like',
          //                   style: Theme.of(context).textTheme.caption,
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Expanded(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 GestureDetector(
          //                   onTap: () {},
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(
          //                       IconBroken.Upload,
          //                       color: Colors.green,
          //                       size: 20,
          //                     ),
          //                   ),
          //                 ),
          //                 Text(
          //                   'Share',
          //                   style: Theme.of(context).textTheme.caption,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    ),
  );
}
