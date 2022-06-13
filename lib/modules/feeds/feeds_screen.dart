import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/new_post/comments_screen/comments_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

import '../../shared/components/components.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // if (state is GetCommentSuccessState)
        // setState(() {

        // });
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: RefreshIndicator(
            onRefresh: () async {
              await cubit.getPosts();
            },
            child: Conditional.single(
              conditionBuilder: (context) =>
                  cubit.posts.isNotEmpty &&
                  cubit.commentsList.length == cubit.posts.length &&
                  cubit.isLiked.length == cubit.posts.length,
              context: context,
              widgetBuilder: (context) => Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.all(8.0),
                          elevation: 10.0,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              const Image(
                                image: NetworkImage(
                                    'https://img.freepik.com/free-photo/pinup-japanese-woman-with-two-combed-hair-buns-touches-cheeks-has-smooth-skin-wears-vivid-rosy-makeup-piercing-nose-wears-sweatshirt-smiles-positively-isolated-pink-background_273609-32313.jpg?t=st=1650817939~exp=1650818539~hmac=dc64ed32353cd1e4bb7bd617606f5ccbee99a8b451218f9545c8eedf80a54a0c&w=996'),
                                fit: BoxFit.cover,
                                height: 200.0,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Communicate with friends ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      iconBroken.Heart,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.posts.length,
                          itemBuilder: (context, index) => buildPostItem(
                            context: context,
                            model: cubit.posts[index],
                            postId: cubit.postsId[index],
                            cubit: cubit,
                            likes: cubit.likesCount[index],
                            comments: cubit.commentsCount[index],
                            index: index,
                            isLiked: cubit.isLiked[index],
                            // isLiked: null,
                          ),

                          // likes: cubit.likes[cubit.postsId[index]][cubit.posts[]],),//cubit.likes['$postId']!.length),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Sorry But No More News...',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  if (state is CreatePostLoadingState)
                    LinearProgressIndicator(),
                ],
              ),
              fallbackBuilder: (context) =>
                  cubit.posts.isEmpty && cubit.commentsList.isEmpty
                      ? Center(
                          child: Text(
                          'No Posts Yet',
                          style: TextStyle(fontSize: 20),
                        ))
                      : Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem({
    required context,
    required PostModel model,
    required String postId,
    required SocialCubit cubit,
    required int likes,
    required int comments,
    required int index,
    required bool isLiked,
  }) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${model.name}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey[800],
                                      // height: 1.0
                                    )),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 16,
                        )
                      ],
                    ),
                    Text('${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            // height: 1.0
                            // fontWeight: FontWeight.w400,
                            // color: Colors.grey[800]
                            )),
                  ],
                )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                    splashRadius: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            if (model.text != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.text}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        height: 1.2, fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Wrap(
                  //   spacing: 1,
                  //   children: [
                  //     for (int i = 0; i < 2; i++)
                  //       defaultTagButton(
                  //         onPressed: () {},
                  //         text: '#sofware',
                  //         context: context,
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            if (model.postImage != null)
              Column(
                children: [
                  Container(
                    height: 180.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage('${model.postImage}'),
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                defaultRowInkWell(
                  onTap: () {},
                  context: context,
                  icon: iconBroken.Heart,
                  iconColor: Colors.red,
                  n: likes,
                  isRight: false,
                ),
                defaultRowInkWell(
                  onTap: () {},
                  context: context,
                  icon: iconBroken.Chat,
                  iconColor: Colors.amber,
                  n: comments,
                  isRight: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel!.image}'),
                ),
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () {
                    // buildCommentBottomSheet();
                    cubit.getComments(postId, index);
                    showDefaultCommentBottomSheet(
                        context, cubit, postId, index);
                  },
                  child: Text('Write a comment...',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[800],
                            // height: 1.0
                          )),
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () {
                    cubit.postLike(postId, index);
                    // cubit.getLikes(postId, index);
                  },
                  label: Text(
                    'Like',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  icon: Icon(
                    iconBroken.Heart,
                    size: 18,
                    color: isLiked ? Colors.red : Colors.grey,
                    // color: Colors.grey,
                  ),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    'Share',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  icon: const Icon(
                    iconBroken.Upload,
                    size: 18,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget defaultRowInkWell(
      {required IconData icon,
      required Color iconColor,
      required int n,
      onTap,
      context,
      required bool isRight}) {
    return Expanded(
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        child: SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment:
                isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
              Text(
                '$n',
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  showDefaultLikesBottomSheet(context, SocialCubit cubit, String postId, index) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.remove,
                            color: Colors.grey[600],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    SocialCubit.get(context).userModel!.image),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    cubit.postComment(postId: postId, currentPost: index,comment: value);
                                    // Navigator.of(context).pop();
                                  },
                                  controller: commentController,
                                  onChanged: (value) {},
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (commentController.text.isNotEmpty) {
                                      cubit.postComment(
                                          comment: commentController.text,
                                          postId: postId,
                                          currentPost: index);
                                      commentController.clear();
                                      // Navigator.of(context).pop();
                                    }

                                  },
                                  icon: Icon(
                                    iconBroken.Send,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: controller,
                              itemCount:
                              cubit.commentsList[postId]?.length ?? 0,
                              itemBuilder: (_, index) {
                                // cubit.printt(cubit.commentsList.toString());

                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                                  child: showDefaultComment(
                                    comment: cubit.commentsList[postId]![index]
                                    ['text'],
                                    date: cubit.commentsList[postId]![index]
                                    ['dateTime'],
                                    image: cubit.commentsList[postId]![index]
                                    ['image'],
                                    name: cubit.commentsList[postId]![index]
                                    ['name'],
                                    uId: cubit.commentsList[postId]![index]
                                    ['uId'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  showDefaultCommentBottomSheet(
      context, SocialCubit cubit, String postId, index) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.remove,
                            color: Colors.grey[600],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    SocialCubit.get(context).userModel!.image),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    cubit.postComment(postId: postId, currentPost: index,comment: value);
                                    // Navigator.of(context).pop();
                                  },
                                  controller: commentController,
                                  onChanged: (value) {},
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (commentController.text.isNotEmpty) {
                                      cubit.postComment(
                                          comment: commentController.text,
                                          postId: postId,
                                          currentPost: index);
                                      commentController.clear();
                                      // Navigator.of(context).pop();
                                    }

                                  },
                                  icon: Icon(
                                    iconBroken.Send,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: controller,
                              itemCount:
                                  cubit.commentsList[postId]?.length ?? 0,
                              itemBuilder: (_, index) {
                                // cubit.printt(cubit.commentsList.toString());

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: showDefaultComment(
                                    comment: cubit.commentsList[postId]![index]
                                        ['text'],
                                    date: cubit.commentsList[postId]![index]
                                        ['dateTime'],
                                    image: cubit.commentsList[postId]![index]
                                        ['image'],
                                    name: cubit.commentsList[postId]![index]
                                        ['name'],
                                    uId: cubit.commentsList[postId]![index]
                                        ['uId'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showDefaultComment({
    required String name,
    required String image,
    required String comment,
    required String uId,
    required String date,
  }) {
    var parsedDate = DateTime.parse(date);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('$image'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey[800],
                                  ),
                        ),
                        Text(
                          '$comment',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (parsedDate.day == DateTime.now().day &&
                    parsedDate.month == DateTime.now().month &&
                    parsedDate.year == DateTime.now().year &&
                    parsedDate.hour == DateTime.now().hour &&
                    parsedDate.minute == DateTime.now().minute)
                  Text(
                    'Just now',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                if (parsedDate.day == DateTime.now().day &&
                    parsedDate.month == DateTime.now().month &&
                    parsedDate.year == DateTime.now().year &&
                    parsedDate.hour == DateTime.now().hour &&
                    DateTime.now().minute - parsedDate.minute < 60 &&
                    DateTime.now().minute - parsedDate.minute > 0)
                  Text(
                    '${DateTime.now().minute - parsedDate.minute} min ago',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                if (parsedDate.day == DateTime.now().day &&
                    parsedDate.month == DateTime.now().month &&
                    parsedDate.year == DateTime.now().year &&
                    DateTime.now().hour - parsedDate.hour < 24 &&
                    DateTime.now().hour - parsedDate.hour > 0)
                  Text(
                    '${DateTime.now().hour - parsedDate.hour} hour ago',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                if (parsedDate.year == DateTime.now().year &&
                    parsedDate.month == DateTime.now().month &&
                    DateTime.now().day - parsedDate.day < 7 &&
                    DateTime.now().day - parsedDate.day > 0)
                  Text(
                    '${DateTime.now().day - parsedDate.day} day ago',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                IconButton(
                  onPressed: () {
                    print('delete');
                  },
                  padding: const EdgeInsets.all(0),
                  splashRadius: .1,
                  // alignment: Alignment.topCenter,
                  visualDensity: VisualDensity.compact,

                  icon: Icon(Icons.more_horiz),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
