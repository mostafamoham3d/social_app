import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is UpdateUserDataErrorState) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'Update your data ',
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        nameController.text = cubit.authUserModel!.name;
        phoneController.text = cubit.authUserModel!.phone;
        bioController.text = cubit.authUserModel!.bio;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
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
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is UpdateUserDataLoadingState)
                      LinearProgressIndicator(),
                    if (state is UpdateUserDataLoadingState)
                      SizedBox(
                        height: 15,
                      ),
                    Container(
                      height: 190,
                      child: Stack(
                        children: [
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
                                    image: cubit.coverImage == null
                                        ? NetworkImage(
                                            '${cubit.authUserModel!.cover}')
                                        : FileImage(cubit.coverImage!)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                                                        SocialCubit.get(context).pickCoverImage(ImageSource.camera);
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
                                                                style:
                                                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
                                                        SocialCubit.get(context)
                                                            .pickCoverImage(ImageSource.gallery);
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
                                                                style:
                                                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).appBarTheme.color,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: cubit.profileImage == null
                                        ? NetworkImage(
                                            '${cubit.authUserModel!.image}',
                                          )
                                        : FileImage(cubit.profileImage!)
                                            as ImageProvider,
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                                                            SocialCubit.get(context)
                                                                .pickProfileImage(ImageSource.camera);
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
                                                                    style:
                                                                    Theme.of(context).textTheme.bodyText2!.copyWith(
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
                                                            SocialCubit.get(context)
                                                                .pickProfileImage(ImageSource.gallery);
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
                                                                    style:
                                                                    Theme.of(context).textTheme.bodyText2!.copyWith(
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
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        IconBroken.Camera,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyText2,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'UserName',
                        prefixIcon: Icon(
                          IconBroken.User,
                        ),
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
                          return 'UserName Can\'t empty';
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
                        hintText: 'Phone No.',
                        prefixIcon: Icon(IconBroken.Call),
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
                          return 'Phone No. Can\'t empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyText2,
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Bio',
                        prefixIcon: Icon(IconBroken.Edit_Square),
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
                          return 'Bio Can\'t empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        cubit.updateUserDate(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
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
                          child: Text(
                            'UPDATE',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Dialog pickCoverDialog(BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    SocialCubit.get(context).pickCoverImage(ImageSource.camera);
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
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
                    SocialCubit.get(context)
                        .pickCoverImage(ImageSource.gallery);
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
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
Dialog pickProfileDialog(context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    SocialCubit.get(context)
                        .pickProfileImage(ImageSource.camera);
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
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
                    SocialCubit.get(context)
                        .pickProfileImage(ImageSource.gallery);
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
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
