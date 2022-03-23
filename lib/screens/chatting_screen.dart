import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/social_app_cubit.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/models/auth_user_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/message_with_image_model.dart';
import 'package:social_app/styles/icon_broken.dart';

class ChattingScreen extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();

  AuthUserModel authUserModel;

  ChattingScreen(this.authUserModel);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverId: authUserModel.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('${authUserModel.image}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${authUserModel.name}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemCount: cubit.messages.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          if (cubit.authUserModel!.uId ==
                              cubit.messages[index].senderId)
                            return buildMyMessageItem(
                                context, cubit.messages[index]);
                          return buildMessageItem(
                              context, cubit.messages[index]);
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                cubit.sendMessage(
                                    receiverId: authUserModel.uId,
                                    text: messageController.text,
                                    dateTime: DateTime.now().toString());
                                messageController.clear();
                              },
                              controller: messageController,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your message...',
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText2),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 65,
                              color: Colors.blue,
                              child: MaterialButton(
                                minWidth: 1,
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          //this right here
                                          child: Container(
                                            height: 150.0,
                                            width: 150.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        SocialCubit.get(context)
                                                            .pickMessageImage(
                                                                ImageSource
                                                                    .camera,
                                                                authUserModel
                                                                    .uId,
                                                                DateTime.now()
                                                                    .toString());
                                                        Navigator.of(context)
                                                            .pop();
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
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .black,
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        SocialCubit.get(context)
                                                            .pickMessageImage(
                                                                ImageSource
                                                                    .gallery,
                                                                authUserModel
                                                                    .uId,
                                                                DateTime.now()
                                                                    .toString());
                                                        Navigator.of(context)
                                                            .pop();
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
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .black,
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
                                      });
                                },
                                child: Icon(
                                  Icons.attach_file,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 65,
                              color: Colors.blue,
                              child: MaterialButton(
                                minWidth: 1,
                                onPressed: () {
                                  cubit.sendMessage(
                                      receiverId: authUserModel.uId,
                                      text: messageController.text,
                                      dateTime: DateTime.now().toString());
                                  messageController.clear();
                                },
                                child: Icon(
                                  IconBroken.Send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
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
        },
      );
    });
  }
}

Widget buildMessageItem(context, MessageModel model) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: !model.text.contains('https')
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomEnd: Radius.circular(10),
                ),
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                '${model.text}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          : Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('${model.text}')),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomEnd: Radius.circular(10),
                ),
                //color: Colors.grey[300],
              ),
            ),
    );
Widget buildMyMessageItem(context, MessageModel model) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: !model.text.contains('http')
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomStart: Radius.circular(10),
                ),
                color: Colors.blue.withOpacity(0.3),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                '${model.text}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          : Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('${model.text}')),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomStart: Radius.circular(10),
                ),
                // color: Colors.blue.withOpacity(0.3),
              ),
            ),
    );
Widget buildMessageWithImageItem(context, MessageWithImageModel model) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage('${model.image}')),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          ),
          //color: Colors.grey[300],
        ),
      ),
    );
Widget buildMyMessageWithImageItem(context, MessageWithImageModel model) =>
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage('${model.image}')),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          ),
          //color: Colors.grey[300],
        ),
      ),
    );
