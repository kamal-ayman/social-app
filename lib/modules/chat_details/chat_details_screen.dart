import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

class ChatDetailsScreen extends StatefulWidget {
  UserModel user;

  ChatDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: widget.user.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SendMessageSuccessState) {
              SocialCubit.get(context).scrollController.jumpTo(
                SocialCubit.get(context).scrollController.position.maxScrollExtent + 100,
              );
            }
          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                elevation: 5,
                shadowColor: Colors.white,
                title: Text(widget.user.name),
                titleSpacing: 10,
                leadingWidth: 75,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        iconBroken.Arrow___Left_2,
                      ),
                      CircleAvatar(
                        // radius: 15,
                        foregroundImage: NetworkImage(widget.user.image),
                      ),
                    ],
                  ),
                ),
              ),
              body: Conditional.single(
                conditionBuilder: (context) =>  cubit.messages.isNotEmpty,
                context: context,
                widgetBuilder: (context) => Column(
                  children: [
                    if (state is SendMessageLoadingState)
                      LinearProgressIndicator(),
                    Expanded(
                      child: ListView.separated(
                          controller: cubit.scrollController,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Message(
                                imageUrl: cubit.messages[index].image,
                                  message: cubit.messages[index].message,
                                  time: cubit.messages[index].time,
                                  isMe: cubit.messages[index].senderId ==
                                      cubit.userModel!.uId),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 4,
                              ),
                          itemCount: SocialCubit.get(context).messages.length),
                    ),
                    buildTextFormField(context, cubit.chatImage, state is SendMessageLoadingState),
                  ],
                ),
                fallbackBuilder: (context) => Column(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        await cubit.sendMessage(
                            receiverId: widget.user.uId.toString(),
                            message: 'Hi, ${widget.user.name}.\nHow are you?',
                            dateTime: DateTime.now().toString());
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Send Hi to ${widget.user.name}...',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    Spacer(),
                    buildTextFormField(context, cubit.chatImage, state is SendMessageLoadingState),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget Message({
    required String message,
    required String? imageUrl,
    required String time,
    required bool isMe,
  }) =>
      Align(
        alignment: !isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[600],
            borderRadius: !isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),

                if (imageUrl != null )
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      Image.network(
                        imageUrl,
                        width: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 5,
                ),
                Text(getTime(time),
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      );

  Widget buildTextFormField(context, chatImage, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: .5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(left: 15.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    // maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (value) {
                      messageController.clear();
                      SocialCubit.get(context).sendMessage(
                          receiverId: widget.user.uId.toString(),
                          message: value,
                          dateTime: DateTime.now().toString());
                    },
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      SocialCubit.get(context)
                          .getImage(imageType: ImageType.chat);
                    },
                    child: const Icon(
                      iconBroken.Image,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () {
                      if (messageController.text.isNotEmpty || chatImage != null) {
                        SocialCubit.get(context).sendMessage(
                            receiverId: widget.user.uId.toString(),
                            message: messageController.text,
                            dateTime: DateTime.now().toString());
                        messageController.clear();
                      }
                    },
                    child: const Icon(
                      iconBroken.Send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (chatImage != null && !state)
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:FileImage(chatImage!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Image(image: FileImage(File('')), width: 100, height: 100),

                    IconButton(
                        splashRadius: .1,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          SocialCubit.get(context).chatImage = null;
                          // chatImage = null;
                          setState(() {});
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(50),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 4,
                                color: Colors.red.withOpacity(.8),
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
      ],
    );
  }

  String getTime(time) {
    DateTime date = DateTime.parse(time);
    return DateFormat.jm().format(date);
  }

  String getDate() {
    return DateFormat.yMMMd().format(DateTime.now());
  }
}
