// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/like_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import '../../modules/new_post/new_post_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(AppInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());
    // print('uId: ' + uId);
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }

  Future updateImages() async {
    if (coverImage != null) {
      await uploadImage(
          imagePath: coverImage!.path,
          imageFile: coverImage,
          isImageProfile: false);
      // print('userModel!.image ::::: ' + userModel!.image);
    }
    if (profileImage != null) {
      await uploadImage(
          imagePath: profileImage!.path,
          imageFile: profileImage,
          isImageProfile: true);
      // print("1 :::::::::::" + coverImageUrl);

      // userModel!.cover = coverImageUrl;
      // profileImage = null;
    }
  }

  void updateUserData({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(UserUpdateLoadingState());
    // print('userModel!.image :::::::::: ' + userModel!.image);
    // print("userModel!.cover :::::::::::" + userModel!.cover);
    updateImages().then((value) {
      userModel = UserModel(
        name: name,
        bio: bio,
        phone: phone,
        email: userModel!.email,
        image: userModel!.image,
        cover: userModel!.cover,
        uId: userModel!.uId,
        isEmailVerified: userModel!.isEmailVerified,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(userModel!.toMap())
          .then((value) {
        // coverImageUrl = '';
        getUserData();
      }).catchError((e) {
        emit(UserUpdateErrorState());
      });
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = const [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      currentIndex = index;
      emit(ChangeButtonNavState());
      if (allUserModel.isEmpty) {
        getAllUsers();
      }
    } else if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeButtonNavState());
    }
  }

  var picker = ImagePicker();
  File? profileImage;
  File? coverImage;
  File? postImage;
  File? chatImage;

  Future<void> getImage({required ImageType imageType}) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery).catchError((e) {
      print(e);
    });
    if (pickedFile != null) {
      if (imageType == ImageType.profile) {
        profileImage = File(pickedFile.path);
        emit(UploadProfileImageSuccessState());
      } else if (imageType == ImageType.cover) {
        coverImage = File(pickedFile.path);
        emit(UploadCoverSuccessState());
      } else if (imageType == ImageType.post) {
        postImage = File(pickedFile.path);
        emit(UploadPostImageSuccessState());
      } else if (imageType == ImageType.chat) {
        chatImage = File(pickedFile.path);
        emit(ChatGetImageSuccessState());
      }
    } else {
      print('no image selected');
      if (imageType == ImageType.profile) {
        profileImage = null;
        emit(UploadProfileImageErrorState());
      } else if (imageType == ImageType.cover) {
        coverImage = null;
        emit(UploadCoverErrorState());
      } else if (imageType == ImageType.post) {
        postImage = null;
        emit(UploadPostImageErrorState());
      } else if (imageType == ImageType.chat) {
        chatImage = null;
        emit(ChatGetImageErrorState());
      }
    }
  }

  Future uploadImage({
    required String imagePath,
    required File? imageFile,
    required bool isImageProfile,
  }) async {
    String imageName =
        imagePath.split('/').last.replaceAll('image_picker', 'OLIVER_');
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/$imageName')
        .putFile(imageFile!)
        .then((val) async {
      await val.ref.getDownloadURL().then((value) {
        if (isImageProfile) {
          userModel!.image = value;
          profileImage = null;
          // print("profileImageUrl :::::: " + userModel!.image);
          emit(UploadProfileImageSuccessState());
        } else {
          userModel!.cover = value;
          coverImage = null;
          // print('coverImageUrl ::::: ' + userModel!.cover);
          emit(UploadCoverSuccessState());
        }
        // print('3profileImage!.path' + profileImage!.path);
      }).catchError((e) {
        print(e);
        if (isImageProfile) {
          emit(UploadProfileImageErrorState());
        } else {
          emit(UploadCoverErrorState());
        }
      });
    }).catchError((e) {
      print(e);
      if (isImageProfile) {
        emit(UploadProfileImageErrorState());
      } else {
        emit(UploadCoverErrorState());
      }
    });
  }

  String? postImageUrl;

  Future<void> uploadPostImage() async {
    if (postImage != null) {
      String imageName =
          postImage!.path.split('/').last.replaceAll('image_picker', 'OLIVER_');
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/$imageName')
          .putFile(postImage!)
          .then((val) async {
        await val.ref.getDownloadURL().then((value) {
          postImageUrl = value;
          emit(UploadPostImageSuccessState());
        }).catchError((error) {
          postImageUrl = null;
          emit(UploadPostImageErrorState());
        });
      }).catchError((e) {
        emit(UploadPostImageErrorState());
      });
    }
  }

  Future createNewPost({
    required String dateTime,
    String? text,
  }) async {
    emit(CreatePostLoadingState());
    uploadPostImage().then((value) async {
      postImage = null;
      PostModel model = PostModel(
        name: userModel!.name,
        image: userModel!.image,
        uId: userModel!.uId,
        dateTime: dateTime,
        text: text,
        postImage: postImageUrl,
      );
      postImageUrl = null;
      await FirebaseFirestore.instance
          .collection('posts')
          .add(model.toMap())
          .then((value) async {
        emit(CreatePostSuccessState());
        // await getPosts();
      }).catchError((e) {
        emit(CreatePostErrorState());
      });
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];

  List<UserModel> allUserModel = [];

  var likes = {};
  List<int> likesCount = [0];
  int countLikesOnePost = 0;
  List<bool> isLiked = [];

  Map<String, List<Map<String, dynamic>>> commentsList = {};
  List<int> commentsCount = [0];
  int countCommentsOnePost = 0;

  getPosts({bool sortAZ = true}) async {
    posts = [];
    postsId = [];
    isLiked = [];
    likesCount = [];
    commentsCount = [];

    // likes = {};
    // commentsList = {};
    emit(GetPostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value0) async {
      if (sortAZ) {
        for (int i = 0; i < value0.docs.length; i++) {
          posts.add(PostModel.fromJson(value0.docs[i].data()));
          postsId.add(value0.docs[i].id);
          await getLikes(value0.docs[i].id, i);
          // print('${value0.docs[i].id} $i');
          await getComments(value0.docs[i].id, i);
        }
      } else {
        for (int i = value0.docs.length - 1; i >= 0; i--) {
          posts.add(PostModel.fromJson(value0.docs[i].data()));
          postsId.add(value0.docs[i].id);
        }
      }
      // printt(likes.toString());
      // printt(isLiked.toString());
      // printt(likesCount.toString());
      // printt(commentsList.length.toString());
      // printt(commentsCount.toString());
      emit(GetPostSuccessState());
      // await getPosts();
    }).catchError((e) {
      print(e);
      emit(GetPostErrorState(e.toString()));
    });
  }

  deletePost(String postId) async {
    emit(DeletePostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) async {
      emit(DeletePostSuccessState());
      await getPosts();
    }).catchError((e) {
      emit(DeletePostErrorState(e.toString()));
    });
  }

  getAllUsers() async {
    allUserModel = [];
    emit(GetAllUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) async {
      value.docs.forEach((element) {
        if (element.id != userModel!.uId) {
          allUserModel.add(UserModel.fromJson(element.data()));
        }
      });
      emit(GetAllUserSuccessState());
    }).catchError((e) {
      emit(GetAllUserErrorState(e.toString()));
      print(e);
    });
  }

  postLike(String postId, int numberOfCurrentPost) {
    isLiked[numberOfCurrentPost] = !isLiked[numberOfCurrentPost];
    if (isLiked[numberOfCurrentPost]) {
      likesCount[numberOfCurrentPost]++;
      LikeModel model = LikeModel(
          dateTime: DateTime.now().toString(),
          uId: userModel!.uId.toString(),
          name: userModel!.name,
          image: userModel!.image,
          like: true);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .set(model.toJson()).then((value) {
        print('like success');
        emit(PostLikeSuccessState());
      }).catchError((e) {
        emit(PostLikeErrorState(e.toString()));
      });
    } else {
      likesCount[numberOfCurrentPost]--;
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .delete()
          .then((value) {
        print('like success');
        emit(PostLikeSuccessState());
      }).catchError((e) {
        emit(PostLikeErrorState(e.toString()));
      });
    }
  }

  List<LikeModel> likeModel = [];
  getLikes(String postId, int numberOfCurrentPost) async {

    countLikesOnePost = 0;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes').orderBy('dateTime')
        .get()
        .then((value) async {

      likesCount.add(value.docs.length);
      likes.addAll({
        postId: value.docs.map((e) => {e.id: e.data()['like']}).toList()
      });

      bool isLike = false;
      for (var e in likes[postId]) {
        if (e[userModel!.uId] != null) {
          isLike = true;
          break;
        }
      }
      if (isLike) {
        isLiked.add(true);
      } else {
        isLiked.add(false);
      }
      emit(GetLikeSuccessState());
    }).catchError((e) {
      print(e);
      emit(GetLikeErrorState(e.toString()));
    });
  }

  postComment(
      {required String postId,
      required String comment,
      required currentPost}) async {
    CommentModel commentModel = CommentModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId.toString(),
      text: comment,
      // postImage: null,
      dateTime: DateTime.now().toString(),
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toJson())
        .then((value) async {
      commentsList[postId]!.add(commentModel.toJson());
      commentsCount[currentPost]++;
      print('comment success');
      emit(PostCommentSuccessState());
    }).catchError((e) {
      emit(PostCommentErrorState(e.toString()));
    });
  }

  getComments(String postId, int numberOfCurrentPost,
      {bool onePost = false}) async {
    // print(numberOfCurrentPost);
    countCommentsOnePost = 0;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .get()
        .then((value) {
      commentsList.addAll({postId: value.docs.map((e) => e.data()).toList()});
      if (commentsList[postId].toString() == '[]') {
        commentsCount.insert(numberOfCurrentPost, 0);
      } else {
        commentsCount.insert(numberOfCurrentPost, commentsList[postId]!.length);
        // commentsList[postId]!.forEach((e) {
        //   print(e.length);
        //   commentsCount.insert(numberOfCurrentPost, countCommentsOnePost);
        //   // commentsCount[numberOfCurrentPost]++;
        // });
      }
      if (onePost) {
        emit(GetCommentSuccessState((value.docs.length)));
      }
    }).catchError((e) {
      if (onePost) {
        emit(GetCommentErrorState(e.toString()));
      }
    });
  }

  Future sendMessage({
    required String receiverId,
    required String message,
    required String dateTime,
  }) async {
    if (chatImage != null) {
      emit(SendMessageLoadingState());
      await uploadImageChat();
    }
    MessageModel messageModel = MessageModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        message: message,
        time: dateTime,
        image: chatImageUrl);
    chatImageUrl = null;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      emit(SendMessageSuccessState());
    }).catchError((e) {
      emit(SendMessageErrorState(e.toString()));
      print(e);
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((e) {
      emit(SendMessageErrorState(e.toString()));
      print(e);
    });
  }

  List<MessageModel> messages = [];
  var scrollController = ScrollController();

  getMessages({
    required String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((e) {
        messages.add(MessageModel.fromJson(e.data()));
      });
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      emit(GetMessageSuccessState());
    });
  }

  deleteMessages({
    required String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.uId)
            .collection('chat')
            .doc(receiverId)
            .collection('messages')
            .doc(element.id)
            .delete()
            .then((value) {
          print('delete success');
        }).catchError((e) {
          print(e);
        });
      });
    });
  }

  String? chatImageUrl;

  Future uploadImageChat() async {
    String imageName =
        chatImage!.path.split('/').last.replaceAll('image_picker', 'OLIVER_');
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/img/$imageName')
        .putFile(chatImage!)
        .then((val) async {
      await val.ref.getDownloadURL().then((value) {
        chatImageUrl = value;
        chatImage = null;
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void printt(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}

enum ImageType { profile, cover, post, chat }
