import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var model = cubit.userModel;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await cubit.getAllUsers();
            },
            child: Conditional.single(
              conditionBuilder: (context) => cubit.allUserModel.isNotEmpty,
              widgetBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildChatItem(context, cubit.allUserModel[index]),
                  separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemCount: cubit.allUserModel.length,
                ),
              ),
              context: context,
              fallbackBuilder: (context) => const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        radius: 0,
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          navigatorTo(context, ChatDetailsScreen(user: user));
        },
        onLongPress: () {
          showDefaultCommentBottomSheet(context, user.name, user.uId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(user.image),
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
                    Text(user.name,
                        style:
                            Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Colors.grey[800],
                                  // height: 1.0
                                )),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                // const SizedBox(height: 10,),
                // Text('hello...',
                //     style: Theme.of(context).textTheme.caption!.copyWith(
                //         height: 1.0,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w400,
                //         color: Colors.grey[800])),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        showDefaultCommentBottomSheet(context, user.name, user.uId);
                      },
                      icon: const Icon(Icons.more_horiz),
                      splashRadius: 20,
                    // enableFeedback: false,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                      DateTime.now().minute.toString() +
                          ':' +
                          DateTime.now().hour.toString(),
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          // height: 1.0
                          // fontWeight: FontWeight.w400,
                          // color: Colors.grey[800]
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDefaultCommentBottomSheet(
      context, name, uid) {
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
                initialChildSize: 0.2,
                minChildSize: 0.2,
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
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            height: 70,

                            child: InkWell(
                              onTap: () {
                                SocialCubit.get(context).deleteMessages(receiverId: uid);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Icon(
                                    iconBroken.Delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Delete $name\'s Chat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
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

}
