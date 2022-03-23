import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/cubit/social_app_states.dart';
import 'package:social_app/helpers/shared_prefs.dart';
import 'package:social_app/models/auth_user_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/screens/chats_screen.dart';
import 'package:social_app/screens/home_screen.dart';
import 'package:social_app/screens/settings_screen.dart';
import 'package:social_app/screens/sign_in_screen.dart';
import 'package:social_app/screens/users_screen.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());
  AuthUserModel? authUserModel;
  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  void changeScreen(index) {
    if (currentIndex == 1) {
      getUsers();
    }
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void sendMessage({required receiverId, required text, required dateTime}) {
    if (text != '') {
      MessageModel model = MessageModel(
          dateTime: dateTime,
          text: text,
          receiverId: receiverId,
          senderId: authUserModel!.uId);
      FirebaseFirestore.instance
          .collection('users')
          .doc(authUserModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(model.toMap())
          .then((value) {
        emit(SendMessageSuccessState());
      }).catchError((error) {
        emit(SendMessageErrorState());
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(authUserModel!.uId)
          .collection('messages')
          .add(model.toMap())
          .then((value) {
        emit(SendMessageSuccessState());
      }).catchError((error) {
        emit(SendMessageErrorState());
      });
    }
  }

  List<MessageModel> messages = [];
  void getMessages({
    required receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authUserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }

  List<String> commentat = [];
  Future getComentat(postId) async {
    commentat = [];
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        commentat.add(element.data()['comment']);
      });
    });
    emit(GetComentatSuccessState());
  }

  Future getUserComentat(postId) async {
    comentatOfUsers = [];
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        comentatOfUsers.add(element.data()['comment']);
      });
    });
  }

  List<int> likesOfUsers = [];
  List<PostModel> usersPost = [];
  List<int> commentOfUsers = [];
  List<String> comentatOfUsers = [];
  List<String> usersPostId = [];
  void getUsersPosts(String userId) {
    // comentatOfUsers = [];
    likesOfUsers = [];
    usersPost = [];
    commentOfUsers = [];
    usersPostId = [];
    emit(SocialGetUserPostLoadingState());
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      event.docs.forEach((element) {
        if (element.data()['uId'] == userId) {
          usersPostId.add(element.id);
          usersPost.add(PostModel.fromJson(element.data()));
          element.reference.collection('likes').snapshots().listen((event) {
            likesOfUsers.add(event.docs.length);
          });
          element.reference.collection('comments').snapshots().listen((event) {
            commentOfUsers.add(event.docs.length);
            event.docs.forEach((element) {
              //comentatOfUsers = [];
              //comentatOfUsers.add(element.data()['comment']);
            });
          });
        }
      });
    });
    emit(SocialGetUserPostSuccessState());
  }

  void getPosts() {
    posts = [];
    postId = [];
    likes = [];
    comments = [];
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      event.docs.forEach((element) {
        postId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
        element.reference.collection('likes').snapshots().listen((event) {
          likes.add(event.docs.length);
          print(postId);
          print(posts);
        });
        element.reference.collection('comments').snapshots().listen((event) {
          comments.add(event.docs.length);
          print(postId);
          print(posts);
          print(comments);
        });
      });
      emit(SocialGetPostSuccessState());
    });
  }

  final ImagePicker picker = ImagePicker();
  File? profileImage;
  File? coverImage;
  File? postImage;
  File? messageImage;
  void pickMessageImage(ImageSource source, receiverId, dateTime) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(messageImage!.path).pathSegments.last}')
          .putFile(messageImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          //add image message
          MessageModel model = MessageModel(
              dateTime: dateTime,
              text: value,
              receiverId: receiverId,
              senderId: authUserModel!.uId);
          FirebaseFirestore.instance
              .collection('users')
              .doc(authUserModel!.uId)
              .collection('chats')
              .doc(receiverId)
              .collection('messages')
              .add(model.toMap())
              .then((value) {
            emit(SendMessageSuccessState());
          }).catchError((error) {
            emit(SendMessageErrorState());
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .collection('chats')
              .doc(authUserModel!.uId)
              .collection('messages')
              .add(model.toMap())
              .then((value) {
            emit(SendMessageSuccessState());
          }).catchError((error) {
            emit(SendMessageErrorState());
          });
        });
      });
      emit(MessagePhotoSelectionSuccessState());
    } else {
      emit(MessagePhotoSelectionErrorState());
    }
  }

  // void uploadProfileImage({
  //   required name,
  //   required bio,
  //   required phone,
  // }) {
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       profileImageUrl = value;
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(authUserModel!.uId)
  //           .update({
  //         'name': name,
  //         'phone': phone,
  //         'bio': bio,
  //         'image': profileImageUrl,
  //       }).then((value) {
  //         getUser();
  //         emit(UpdateUserDataSuccessState());
  //       }).catchError((error) {
  //         emit(UpdateUserDataErrorState());
  //       });
  //       emit(ProfilePhotoUploadSuccessState());
  //     }).catchError((error) {
  //       emit(ProfilePhotoUploadErrorState());
  //     });
  //   }).catchError((error) {
  //     emit(ProfilePhotoUploadErrorState());
  //   });
  // }
  void pickProfileImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PostPhotoSelectionSuccessState());
    } else {
      emit(PostPhotoSelectionErrorState());
    }
  }

  void pickPostImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(ProfilePhotoSelectionSuccessState());
    } else {
      emit(ProfilePhotoSelectionErrorState());
    }
  }

  List<int> likes = [];
  List<int> comments = [];
  String profileImageUrl = '';
  String coverImageUrl = '';
  String postImageUrl = '';
  void pickCoverImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(ProfilePhotoSelectionSuccessState());
    } else {
      emit(ProfilePhotoSelectionErrorState());
    }
  }

  List<String> appBarTitle = ['Home', 'Chats', 'Users', 'Settings'];
  List<PostModel> posts = [];
  List<String> postId = [];

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(authUserModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  void commentToPost({required String postId, required String comment}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': comment,
      'name': authUserModel!.name,
      'uId': authUserModel!.uId,
    }).then((value) {
      emit(AddCommentToPostSuccessState());
    }).catchError((error) {
      emit(AddCommentToPostErrorState());
    });
  }

  void getComments() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      event.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          print(comments);
        });
      });
    });
    emit(GetCommentsSuccessState());
  }

  // get().then((value) {
  // value.docs.forEach((element) {
  // element.reference.collection('comments').get().then((value) {
  //
  // });
  // });
  //
  // });
  List<AuthUserModel> chattedWithUsers = [];
  List<AuthUserModel> searchedUsers = [];
  // void getChattedWithUsers() {
  //   emit(GetChattedWithUsersLoadingState());
  //   chattedWithUsers = [];
  //   FirebaseFirestore.instance.collection('users').doc(authUserModel!.uId)
  //   .collection('chats')
  // }

  void getSearchedUsers(String key) {
    searchedUsers = [];
    if (key == '') {
      searchedUsers = [];
      emit(SearchUserErrorState());
    }
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['name'] == key &&
            element.data()['uId'] != authUserModel!.uId) {
          searchedUsers.add(AuthUserModel.fromJson(element.data()));
          emit(SearchUserSuccessState());
        }
      });
    }).catchError((error) {
      emit(SearchUserErrorState());
    });
  }

  List<AuthUserModel> usersList = [];
  void getUsers() {
    if (usersList.length == 0)
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          if (element.data()['uId'] != authUserModel!.uId)
            usersList.add(AuthUserModel.fromJson(element.data()));
        });
      });
    emit(SocialGetUsersSuccessState());
  }

  // get().then((value) {
  // value.docs.forEach((element) {
  //
  //
  // });
  //
  // }).catchError((error) {
  // emit(SocialGetUsersErrorState(error.toString()));
  // });
  void deletePost(String postId, index) {
    if (authUserModel!.uId == posts[index].uId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .delete()
          .then((value) {
        getPosts();
        emit(DeletePostSuccessState());
      }).catchError((error) {
        emit(DeletePostErrorState());
      });
      emit(DeletePostSuccessState());
    } else {
      emit(CanotdeletePostState());
    }
  }

  static SocialCubit get(context) => BlocProvider.of(context);
  void getUser() {
    emit(SocialGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      authUserModel = AuthUserModel.fromJson(value.data()!);
      emit(SocialGetUserDataSuccessState(authUserModel!));
    }).catchError((error) {
      emit(SocialGetUserDataErrorState(error.toString()));
    });
  }

  void uploadProfileImage({
    required name,
    required bio,
    required phone,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(authUserModel!.uId)
            .update({
          'name': name,
          'phone': phone,
          'bio': bio,
          'image': profileImageUrl,
        }).then((value) {
          getUser();
          emit(UpdateUserDataSuccessState());
        }).catchError((error) {
          emit(UpdateUserDataErrorState());
        });
        emit(ProfilePhotoUploadSuccessState());
      }).catchError((error) {
        emit(ProfilePhotoUploadErrorState());
      });
    }).catchError((error) {
      emit(ProfilePhotoUploadErrorState());
    });
  }

  void uploadPostImage({
    required date,
    required text,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postImageUrl = value;
        FirebaseFirestore.instance.collection('posts').add({
          'name': authUserModel!.name,
          'date': date,
          'text': text ?? '',
          'image': authUserModel!.image,
          'postImage': value,
          'uId': authUserModel!.uId,
        }).then((value) {
          postImage = null;
          emit(CreatePostSuccessState());
        }).catchError((error) {
          emit(CreatePostErrorState());
        });
        emit(UploadPostPhotoSuccessState());
      }).catchError((error) {
        emit(UploadPostPhotoErrorState());
      });
    }).catchError((error) {
      emit(UploadPostPhotoErrorState());
    });
  }

  void uploadCoverImage({
    required name,
    required bio,
    required phone,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(authUserModel!.uId)
            .update({
          'name': name,
          'phone': phone,
          'bio': bio,
          'cover': coverImageUrl,
        }).then((value) {
          getUser();
          emit(UpdateUserDataSuccessState());
        }).catchError((error) {
          emit(UpdateUserDataErrorState());
        });
        emit(CoverPhotoUploadSuccessState());
      }).catchError((error) {
        emit(CoverPhotoUploadErrorState());
      });
    }).catchError((error) {
      emit(CoverPhotoUploadErrorState());
    });
  }

  void deletePostPhoto() {
    postImage = null;
    emit(DeletePostPhotoState());
  }

  void createPost({
    required date,
    required text,
  }) {
    emit(CreatePostLoadingState());
    if (postImage != null && text != '') {
      uploadPostImage(date: date, text: text);
    } else if (postImage != null) {
      uploadPostImage(date: date, text: text);
    } else if (postImage == null && text == '') {
      emit(CreatePostErrorState());
    } else if (text != '') {
      FirebaseFirestore.instance.collection('posts').add({
        'name': authUserModel!.name,
        'date': date,
        'text': text,
        'image': authUserModel!.image,
        'postImage': '',
        'uId': authUserModel!.uId,
      }).then((value) {
        emit(CreatePostSuccessState());
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }
  }

  void updateUserDate({
    required name,
    required phone,
    required bio,
  }) async {
    emit(UpdateUserDataLoadingState());
    if (profileImage != null) {
      uploadProfileImage(name: name, bio: bio, phone: phone);
    } else if (coverImage != null) {
      uploadCoverImage(name: name, bio: bio, phone: phone);
    } else if (name == authUserModel!.name &&
        bio == authUserModel!.bio &&
        profileImage == null &&
        coverImage == null) {
      emit(UpdateUserDataErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(authUserModel!.uId)
          .update({
        'name': name,
        'phone': phone,
        'bio': bio,
        'image': authUserModel!.image,
        'cover': authUserModel!.cover,
      }).then((value) {
        getUser();
        emit(UpdateUserDataSuccessState());
      }).catchError((error) {
        emit(UpdateUserDataErrorState());
      });
    }
  }

  void logOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => LogInScreen()));
    SharedPrefs.removeData('uId');
    emit(LogOutState());
  }
}
