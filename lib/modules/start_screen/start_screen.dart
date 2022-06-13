// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_initializing_formals, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/signup/signup_screen.dart';
import 'package:social_app/shared/components/components.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final p = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: HexColor('#006bff'),
            height: height,
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: p + 20, horizontal: 30),
            child: Text('Social App', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, fontFamily: 'f', color: Colors.white),),
          ),
          Transform.translate(
            offset: Offset(0, height * .65),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Hello Friend', style: TextStyle(fontSize: 30,color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'f'),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('so excited to login!', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      defaultButton(text: 'Log in', onPressed: (){
                        navigatorTo(context, LoginScreen());
                      }, fontColor:HexColor('#006bff'), bg: Colors.white , ),
                      SizedBox(height: 10,),
                      defaultButton(text: 'Sign up', onPressed: (){
                        navigatorTo(context, SignupScreen());
                      }, outline: true, bg:HexColor('#006bff'), fontColor:Colors.white,outlineColor: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
