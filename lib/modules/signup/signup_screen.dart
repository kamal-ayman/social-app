// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';
import '../../shared/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SignupScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            toastShow(
              text: state.error.toString().split(']')[1],
              state: ToastStates.ERROR,
            );
          }
          if (state is CreateUserSuccessState){
            SocialCubit.get(context).getUserData();
            navigatorAndFinish(context, SocialLayout(), previous: false);
          }
        },
        builder: (context, state) {
          var cubit = SignupCubit.get(context);
          final appBar = AppBar();
          final height =
              MediaQuery.of(context).size.height - appBar.preferredSize.height;
          return Scaffold(
            // appBar: appBar,
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: ClipPath(
                            clipper: WaveClipper(),
                            child: Container(
                              color: HexColor('#006bff'),
                              height: height - height * 0.65,
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: WaveClipper(),
                          child: Container(
                            color: HexColor('#006bff'),
                            height: height - height * 0.65 - 20,
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 50, left: 25.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        child: Text(
                                          "Create account now!\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                            color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Icon(iconBroken.Login, color: Colors.white, size: 30,)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0, height * .1 - 70),
                          child: Column(
                            children: [
                              buildTextFormField(
                                context: context,
                                controller: nameController,
                                prefix: Icons.person_outline,
                                type: TextInputType.name,
                                text: 'Name',
                                onChange: (String? str) {
                                  cubit.checkReadyName(str);
                                },
                                suffix: cubit.isNameReady
                                    ? Icons.done
                                    : Icons.error_outline,
                                isblue: cubit.isNameReady,
                                validate: (String? value) {
                                  if (value!.isEmpty || !cubit.isNameReady) {
                                    return 'Enter your name';
                                  }
                                  return null;
                                },
                              ),
                              buildTextFormField(
                                context: context,
                                controller: emailController,
                                prefix: Icons.email_outlined,
                                type: TextInputType.emailAddress,
                                suffix: cubit.isEmailReady
                                    ? Icons.done
                                    : Icons.error_outline,
                                onChange: (String? str) {
                                  cubit.checkReadyEmail(str);
                                },
                                text: 'Email',
                                isblue: cubit.isEmailReady,
                                validate: (String? value) {
                                  if (value!.isEmpty || !cubit.isEmailReady) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              buildTextFormField(
                                context: context,
                                controller: phoneController,
                                prefix: Icons.phone_outlined,
                                type: TextInputType.phone,
                                suffix: cubit.isPhoneReady
                                    ? Icons.done
                                    : Icons.error_outline,
                                text: 'Phone',
                                onChange: (String? str) {
                                  cubit.checkReadyPhone(str);
                                },
                                isblue: cubit.isPhoneReady,
                                validate: (String? value) {
                                  if (value!.isEmpty || !cubit.isPhoneReady) {
                                    return 'Enter Valid Phone Number';
                                  }
                                  return null;
                                },
                              ),
                              buildTextFormField(
                                onChange: (String? value) {
                                  cubit.checkReadyPassConfirm(value);
                                },
                                context: context,
                                controller: passwordController,
                                prefix: Icons.lock_outline,
                                type: TextInputType.visiblePassword,
                                suffix: cubit.icon,
                                text: 'Password',
                                suffixButton: () {
                                  cubit.switchIcon();
                                },
                                obscureText: cubit.password,
                                isblue: !cubit.password,
                                validate: (String? value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Enter your password equal 6 or more digits';
                                  }
                                  return null;
                                },
                              ),
                              buildTextFormField(
                                onChange: (String? value) {
                                  cubit.checkReadyPassConfirmAgain(value);
                                },
                                context: context,
                                controller: passwordConfirmController,
                                prefix: Icons.lock_outline,
                                type: TextInputType.visiblePassword,
                                suffix: cubit.isPassReady
                                    ? Icons.done
                                    : Icons.error_outline,
                                text: 'Password Confirm',
                                suffixButton: () {
                                  cubit.switchIcon();
                                },
                                obscureText: cubit.password,
                                isblue: cubit.isPassReady,
                                validate: (String? value) {
                                  if (cubit.passwordConfirm != value) {
                                    return 'password is not true please rewrite your password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Conditional.single(
                                      context: context,
                                      conditionBuilder: (context) =>
                                          state is! RegisterLoadingState,
                                      widgetBuilder: (context) => defaultButton(
                                          text: 'Sign up',
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              cubit.userRegister(
                                                  email: emailController.text,
                                                  name: nameController.text,
                                                  password: passwordController.text,
                                                  phone: phoneController.text);
                                            }
                                          }),
                                      fallbackBuilder: (context) =>
                                          CircularProgressIndicator(),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                  color: Colors.grey, fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    defaultButton(
                                        text: 'Log in',
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginScreen(),
                                            ),
                                          );
                                        },
                                        outline: true,
                                        outlineColor: Colors.grey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
