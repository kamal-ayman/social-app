

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var textController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return BlocProvider(
          create: (BuildContext context) => PostCubit(),
          child: BlocConsumer<PostCubit, PostStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: defaultAppbar(
                    function: () {
                        Navigator.pop(context);

                    },
                    actions: [
                      TextButton(
                          onPressed: textController.text != '' ||
                                  cubit.postImage != null
                              ? () async {
                                  var date = DateTime.now();
                                  Navigator.pop(context);
                                  await cubit.createNewPost(
                                      dateTime: date.toString(),
                                      text: textController.text == ''
                                          ? null
                                          : textController.text).then((value) {
                                    cubit.getPosts();
                                  });


                                }
                              : null,
                          child: const Text('POST')),
                    ],
                    title: 'Create Post',
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: NetworkImage(
                                            '${cubit.userModel!.image}'),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${cubit.userModel!.name}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color:
                                                          Colors.grey[800]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: double.maxFinite,
                                    child: TextField(
                                      controller: textController,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (val) {
                                        setState(() {});
                                      },
                                      maxLines: null,
                                      autofocus: true,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'jannah',
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'What\'s on your mind?',
                                        hintStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'jannah',
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (cubit.postImage != null)
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Image(image: FileImage(cubit.postImage!)),
                                  IconButton(
                                      splashRadius: .1,
                                      onPressed: () {
                                        cubit.postImage = null;
                                        setState(() {});
                                      },
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional
                                                  .circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 4,
                                              color:
                                                  Colors.red.withOpacity(.8),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.close_sharp,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Spacer(),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      cubit.getImage(
                                          imageType: ImageType.post);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(iconBroken.Image),
                                        Text('Add Image'),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      '# Add Tags',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }

  Widget buildBottomSheetButton({
    required function,
    required String text,
    required Color textColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return MaterialButton(
        onPressed: function,
        height: 70,
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            Text(
              '  ${text}',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ],
        ));
  }

  buildBottomSheet() {
    return scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        color: Colors.grey[200],
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetButton(
                icon: iconBroken.Delete,
                function: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                textColor: Colors.red,
                iconColor: Colors.red,
                text: 'Discard Post',
              ),
              buildBottomSheetButton(
                icon: iconBroken.Send,
                function: () {
                  Navigator.pop(context);
                },
                textColor: Colors.blue,
                iconColor: Colors.blue,
                text: 'Continue editing',
              ),
            ],
          ),
        ),
      );
    });
  }
}
