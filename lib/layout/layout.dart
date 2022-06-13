import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/notifications/notifications_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

class SocialLayout extends StatefulWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  State<SocialLayout> createState() => _SocialLayoutState();
}

class _SocialLayoutState extends State<SocialLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is NewPostState) {
          navigatorTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var model = cubit.userModel;
        return WillPopScope(
          onWillPop: () async {
            if (cubit.currentIndex != 0) {
              cubit.changeBottomNav(0);
            } else {
              showExitDialog(context: context, cubit: cubit);
              // SystemNavigator.pop();
            }
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              actions: [
                IconButton(
                    onPressed: () {
                      navigatorTo(context, const NotificationsScreen());
                    },
                    icon: const Icon(iconBroken.Notification),
                    splashRadius: 20),
                IconButton(
                    onPressed: () {
                      navigatorTo(context, const SearchScreen());
                    },
                    icon: const Icon(iconBroken.Search),
                    splashRadius: 20),
              ],
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder: (context) => cubit.userModel != null,
              widgetBuilder: (context) {
                return Stack(
                  children: [
                    cubit.screens[cubit.currentIndex],
                    if (cubit.userModel!.isEmailVerified == true ||
                        cubit.userModel!.isEmailVerified == null &&
                            cubit.currentIndex == 0)
                      Container(
                        color: Colors.amber.withOpacity(1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline),
                              const SizedBox(
                                width: 10,
                              ),
                              const Expanded(
                                  child: Text('Please verify your email')),
                              const SizedBox(width: 20),
                              defaultTextButton(
                                  text: 'send'.toUpperCase(),
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification()
                                        .then((value) {
                                      toastShow(
                                          text: 'check your email',
                                          state: ToastStates.SUCCESS);
                                    }).catchError((e) {
                                      toastShow(
                                          text: 'send error',
                                          state: ToastStates.ERROR);
                                    });
                                  },
                                  context: context)
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
              fallbackBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(iconBroken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(iconBroken.Chat), label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(iconBroken.Paper_Upload), label: 'Post'),
                BottomNavigationBarItem(
                    icon: Icon(iconBroken.Location), label: 'Users'),
                BottomNavigationBarItem(
                    icon: Icon(iconBroken.Setting), label: 'Settings'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showExitDialog(
      {required context, required SocialCubit cubit}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Social App'),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListBody(
              children: const [
                Text(
                  'Are you sure to exit?',
                ),
              ],
            ),
          ),
          actions: [
            defaultTextButton(
                text: 'No',
                onPressed: () {
                  Navigator.of(context).pop();
                },
                context: context),

            defaultTextButton(
                text: 'Yes',
                onPressed: () {
                  SystemNavigator.pop();
                },
                context: context),

            // const SizedBox(height: 40, width: 10)
          ],
        );
      },
    );
  }
}
