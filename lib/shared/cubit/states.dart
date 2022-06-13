abstract class SocialStates {}

class AppInitialState extends SocialStates {}

class GetUserLoadingState extends SocialStates {}

class GetUserSuccessState extends SocialStates {}

class GetUserErrorState extends SocialStates {
  final String error;

  GetUserErrorState(this.error);
}
class GetAllUserLoadingState extends SocialStates {}

class GetAllUserSuccessState extends SocialStates {}

class GetAllUserErrorState extends SocialStates {
  final String error;

  GetAllUserErrorState(this.error);
}

class ChangeButtonNavState extends SocialStates {}

class NewPostState extends SocialStates {}

class UploadProfileImageSuccessState extends SocialStates {}

class UploadProfileImageErrorState extends SocialStates {}

class UploadCoverSuccessState extends SocialStates {}

class UploadCoverErrorState extends SocialStates {}

class UserUpdateLoadingState extends SocialStates {}

class UserUpdateErrorState extends SocialStates {}

// create post

class CreatePostLoadingState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class UploadPostImageSuccessState extends SocialStates {}

class UploadPostImageErrorState extends SocialStates {}

// get posts

class GetPostLoadingState extends SocialStates {}

class GetPostSuccessState extends SocialStates {}

class GetPostErrorState extends SocialStates {
  final String error;

  GetPostErrorState(this.error);
}

// delete post

class DeletePostLoadingState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class DeletePostErrorState extends SocialStates {
  final String error;

  DeletePostErrorState(this.error);
}

// like posts

class GetLikeSuccessState extends SocialStates {}

class GetLikeErrorState extends SocialStates {
  final String error;

  GetLikeErrorState(this.error);
}

// post like...
class PostLikeSuccessState extends SocialStates {}

class PostLikeErrorState extends SocialStates {
  final String error;

  PostLikeErrorState(this.error);
}

// post comment

class PostCommentSuccessState extends SocialStates {}

class PostCommentErrorState extends SocialStates {
  final String error;

  PostCommentErrorState(this.error);
}

// get comments

class GetCommentSuccessState extends SocialStates {
  final length;

  GetCommentSuccessState(this.length);
}

class GetCommentErrorState extends SocialStates {
  final String error;

  GetCommentErrorState(this.error);
}

// chats

class SendMessageLoadingState extends SocialStates {}
class SendMessageSuccessState extends SocialStates {}

class SendMessageErrorState extends SocialStates {
  final String error;

  SendMessageErrorState(this.error);
}

class GetMessageSuccessState extends SocialStates {}

class GetMessageErrorState extends SocialStates {
  final String error;

  GetMessageErrorState(this.error);
}

class DeleteMessageSuccessState extends SocialStates {}

class DeleteMessageErrorState extends SocialStates {
  final String error;

  DeleteMessageErrorState(this.error);
}


// chat get image from gallery
class ChatGetImageSuccessState extends SocialStates {}

class ChatGetImageErrorState extends SocialStates {}
