import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getPosts();
        SocialCubit.get(context).getComments();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialGetUserDataErrorState) {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                text: state.error,
              );
            }
            if (state is CanotdeletePostState) {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                text: 'Can\'t delete someone else\'s post',
              );
            }
          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  cubit.getPosts();
                  cubit.getComments();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (!FirebaseAuth.instance.currentUser!.emailVerified)
                        Container(
                          color: Colors.amber.withOpacity(.6),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text('Verify your email'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                  },
                                  child: Text('SEND'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Card(
                            margin: EdgeInsets.all(5),
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image(
                              width: double.infinity,
                              image: NetworkImage(
                                  'https://image.freepik.com/free-photo/charming-middle-aged-woman-sits-queue-near-cabinet-poses-chair-against-blue-wall-uses-smartphone_273609-45478.jpg'),
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Communicate with others',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    //color: Colors.white,
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (cubit.authUserModel != null && cubit.posts.length > 0)
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cubit.posts.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  buildPostItem(
                                      context, cubit.posts[index], index),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }),
                      if (cubit.authUserModel == null ||
                          cubit.posts.length == 0)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Dialog commentDialog(context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Container();
            },
            separatorBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 1,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey[300],
              );
            },
            itemCount: SocialCubit.get(context).commentat.length),
      ),
    );
Widget buildPostItem(context, PostModel model, index) {
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
              IconButton(
                onPressed: () {
                  SocialCubit.get(context).deletePost(
                      SocialCubit.get(context).postId[index], index);
                },
                icon: Icon(IconBroken.Delete),
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
          // Container(
          //   padding: EdgeInsets.only(bottom: 10, top: 5),
          //   width: double.infinity,
          //   child: Wrap(
          //     children: [
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(left: 6),
          //         height: 20,
          //         child: MaterialButton(
          //           minWidth: 1,
          //           padding: EdgeInsets.zero,
          //           onPressed: () {},
          //           child: Text(
          //             '#Software',
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                        '${SocialCubit.get(context).likes[index] ?? '0'}',
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
                        '${SocialCubit.get(context).comments[index]}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      InkWell(
                        onTap: () async {
                          await SocialCubit.get(context).getComentat(
                              SocialCubit.get(context).postId[index]);
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
                                              .commentat
                                              .length >
                                          0
                                      ? ListView.separated(
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.all(20),
                                              child: Center(
                                                child: Text(
                                                  '${SocialCubit.get(context).commentat[index]}',
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
                                              .commentat
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
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '${SocialCubit.get(context).authUserModel!.image}'),
                radius: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TextFormField(
                onFieldSubmitted: (value) {
                  SocialCubit.get(context).commentToPost(
                      postId: SocialCubit.get(context).postId[index],
                      comment: commentController.text);
                },
                controller: commentController,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 14),
                decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 12,
                        )),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              SocialCubit.get(context).likePost(
                                  SocialCubit.get(context).postId[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                IconBroken.Upload,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Share',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
