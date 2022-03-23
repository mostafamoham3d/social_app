import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/styles/icon_broken.dart';

class PostScreen extends StatelessWidget {
  final text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreatePostErrorState) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'Create a post ',
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        Dialog pickPostDialog = Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          child: Container(
            height: 150.0,
            width: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                    child: TextButton(
                      onPressed: () {
                        cubit.pickPostImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Camera,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Camera',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                    child: TextButton(
                      onPressed: () {
                        cubit.pickPostImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Image,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Gallery',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  cubit.createPost(
                      date: DateTime.now().toString(), text: text.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
            title: Text('Create Post'),
            titleSpacing: 5,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is CreatePostLoadingState)
                    LinearProgressIndicator(),
                  if (state is CreatePostLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage('${cubit.authUserModel!.image}'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '${cubit.authUserModel!.name}',
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
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: text,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind...',
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Stack(
                    alignment: Alignment.topRight,
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
                            image: cubit.postImage == null
                                ? NetworkImage(
                                    'https://i.stack.imgur.com/tDPMH.png')
                                : FileImage(cubit.postImage!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          onPressed: () {
                            //close post
                            cubit.deletePostPhoto();
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Add Photo',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.blue,
                                    ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return Builder(
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      //this right here
                                      child: Container(
                                        color: Theme.of(context).cardColor,
                                        height: 150.0,
                                        width: 150.0,
                                        child: Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      SocialCubit.get(context)
                                                          .pickPostImage(
                                                              ImageSource
                                                                  .camera);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          IconBroken.Camera,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .color,
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Camera',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2!,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 1,
                                                color: Colors.grey,
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      SocialCubit.get(context)
                                                          .pickPostImage(
                                                              ImageSource
                                                                  .gallery);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          IconBroken.Image,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .color,
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Gallery',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2!,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '#tags',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Colors.blue,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
