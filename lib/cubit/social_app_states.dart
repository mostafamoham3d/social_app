import 'package:social_app/models/auth_user_model.dart';

abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserDataLoadingState extends SocialStates {}

class SocialGetUserDataSuccessState extends SocialStates {
  AuthUserModel authUserModel;
  SocialGetUserDataSuccessState(this.authUserModel);
}

class SocialGetUserDataErrorState extends SocialStates {
  String error;
  SocialGetUserDataErrorState(this.error);
}

class GetChattedWithUsersLoadingState extends SocialStates {}

class GetChattedWithUsersSuccessState extends SocialStates {}

class SocialGetPostLoadingState extends SocialStates {}

class SocialGetPostSuccessState extends SocialStates {}

class SocialGetUserPostLoadingState extends SocialStates {}

class SocialGetUserPostSuccessState extends SocialStates {}

class SocialGetPostErrorState extends SocialStates {
  String error;
  SocialGetPostErrorState(this.error);
}

class SocialGetUsersSuccessState extends SocialStates {}

class SocialGetUsersErrorState extends SocialStates {
  String error;
  SocialGetUsersErrorState(this.error);
}

class LikePostSuccessState extends SocialStates {}

class LikePostErrorState extends SocialStates {}

class AddCommentToPostSuccessState extends SocialStates {}

class GetCommentsSuccessState extends SocialStates {}

class AddCommentToPostErrorState extends SocialStates {}

class ChangeBottomNavState extends SocialStates {}

class ChangeBottomPostState extends SocialStates {}

class LogOutState extends SocialStates {}

class CoverPhotoSelectionSuccessState extends SocialStates {}

class CoverPhotoSelectionErrorState extends SocialStates {}

class ProfilePhotoSelectionSuccessState extends SocialStates {}

class ProfilePhotoSelectionErrorState extends SocialStates {}

class PostPhotoSelectionSuccessState extends SocialStates {}

class PostPhotoSelectionErrorState extends SocialStates {}

class MessagePhotoSelectionSuccessState extends SocialStates {}

class MessagePhotoSelectionErrorState extends SocialStates {}

class CoverPhotoUploadSuccessState extends SocialStates {}

class CoverPhotoUploadErrorState extends SocialStates {}

class ProfilePhotoUploadSuccessState extends SocialStates {}

class ProfilePhotoUploadErrorState extends SocialStates {}

class UpdateUserDataSuccessState extends SocialStates {}

class UpdateUserDataLoadingState extends SocialStates {}

class UpdateUserDataErrorState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class DeletePostErrorState extends SocialStates {}

class UploadPostPhotoSuccessState extends SocialStates {}

class UploadPostPhotoLoadingState extends SocialStates {}

class UploadPostPhotoErrorState extends SocialStates {}

class CreatePostLoadingState extends SocialStates {}

class DeletePostPhotoState extends SocialStates {}

class SendMessageSuccessState extends SocialStates {}

class SendMessageErrorState extends SocialStates {}

class GetMessageSuccessState extends SocialStates {}

class GetComentatSuccessState extends SocialStates {}

class GetMessageErrorState extends SocialStates {}

class CanotdeletePostState extends SocialStates {}

class SearchUserSuccessState extends SocialStates {}

class SearchUserErrorState extends SocialStates {}

class UploadMessageImageSuccessState extends SocialStates {}

class UploadMessageImageErrorState extends SocialStates {}
