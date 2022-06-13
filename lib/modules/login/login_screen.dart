// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_initializing_formals, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/signup/signup_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

import '../../shared/cubit/cubit.dart';
import '../feeds/feeds_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            toastShow(
              text: state.error.toString().split(']')[1],
              state: ToastStates.ERROR,
            );
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId);
            SocialCubit.get(context).getUserData();
            navigatorAndFinish(context, SocialLayout(), previous: false);
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Welcome Back",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        iconBroken.Login,
                                        color: Colors.white,
                                        size: 30,
                                      )
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
                                textInputAction: TextInputAction.done,
                                isblue: cubit.isEmailReady,
                                validate: (String? value) {
                                  if (value!.isEmpty || !cubit.isEmailReady) {
                                    return 'Enter your email';
                                  }
                                  return null;
                                },
                              ),
                              buildTextFormField(
                                context: context,
                                controller: passwordController,
                                prefix: Icons.lock_outline,
                                type: TextInputType.emailAddress,
                                suffix: cubit.icon,
                                text: 'Password',
                                textInputAction: TextInputAction.done,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    defaultTextButton(
                                        context: context,
                                        onPressed: () {},
                                        text: 'Forgot password?',
                                        fw: FontWeight.bold),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Conditional.single(
                                      context: context,
                                      conditionBuilder: (context) =>
                                          state is! LoginLoadingState,
                                      widgetBuilder: (context) => defaultButton(
                                          text: 'Log in',
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.userLogin(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text);
                                            }
                                          }),
                                      fallbackBuilder: (context) =>
                                          CircularProgressIndicator(),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
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
                                                  color: Colors.grey,
                                                  fontSize: 16),
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    defaultButton(
                                        text: 'Sign up',
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignupScreen(),
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
