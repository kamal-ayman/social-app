import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var model = cubit.userModel;
        File? profileImage = SocialCubit.get(context).profileImage;
        File? coverImage = SocialCubit.get(context).coverImage;
        nameController.text = model!.name;
        bioController.text = model.bio;
        phoneController.text = model.phone;
        return Form(
          key: formkey,
          child: Scaffold(
            appBar: defaultAppbar(
              function: () {
                Navigator.pop(context);
              },
              title: 'Edit profile',
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        SocialCubit.get(context).updateUserData(
                          name: nameController.text,
                          bio: bioController.text,
                          phone: phoneController.text,
                        );
                        toastShow(
                            text: 'Profile Updated',
                            state: ToastStates.SUCCESS);
                        Navigator.pop(context);

                      }
                    },
                    child: const Text('update', style: TextStyle(fontSize: 16)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      splashFactory: InkSplash.splashFactory,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is UserUpdateLoadingState)
                      Column(
                        children: const [
                          LinearProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 190,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 140.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                      image: DecorationImage(
                                        image: coverImage == null
                                            ? NetworkImage(model.cover)
                                            : FileImage(coverImage)
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      cubit.getImage(
                                          imageType: ImageType.cover);
                                    },
                                    icon: CircleAvatar(
                                      backgroundColor:
                                          Colors.blue.withOpacity(.7),
                                      child: const Icon(
                                        iconBroken.Camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                    splashRadius: 20,
                                  ),
                                )
                              ],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: const CircularProgressIndicator(),
                                  foregroundImage: profileImage == null
                                      ? NetworkImage(model.image)
                                      : FileImage(profileImage)
                                          as ImageProvider,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  cubit.getImage(imageType: ImageType.profile);
                                  // cubit.uploadProfile(profileImage!.path, profileImage);
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(.8),
                                  child: const Icon(
                                    iconBroken.Camera,
                                    color: Colors.white,
                                  ),
                                ),
                                splashRadius: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      context: context,
                      controller: nameController,
                      text: 'Name',
                      type: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefix: iconBroken.User,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter validate name';
                        }
                        return null;
                      },
                    ),
                    buildTextFormField(
                      context: context,
                      controller: bioController,
                      text: 'Bio',
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      prefix: iconBroken.Edit,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter validate bio';
                        }
                        return null;
                      },
                    ),
                    buildTextFormField(
                      context: context,
                      controller: phoneController,
                      text: 'Phone',
                      type: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefix: iconBroken.Call,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter validate phone';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
