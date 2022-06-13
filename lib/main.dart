// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, empty_catches, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/styles/themes.dart';
import 'modules/start_screen/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  print(message.data);


  toastShow(text: 'on message background handler', state: ToastStates.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print('Token: $token');
  FirebaseMessaging.onMessage.listen((event) {
    toastShow(text: 'on message', state: ToastStates.SUCCESS);
    print(event.data);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    toastShow(text: 'on message opened app', state: ToastStates.SUCCESS);
    print(event.data);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
  ));
  try {
    uId = CacheHelper.getData(key: 'uId');
  } catch (e) {
    CacheHelper.saveData(key: 'uId', value: "");
  }
  print('uId: ' + uId);

  Widget widget;

  if (uId != "") {
    widget = SocialLayout();
  } else {
    widget = StartScreen();
  }
  runApp(SocialApp(startWidget: widget));
}

class SocialApp extends StatelessWidget {
  Widget startWidget;

  SocialApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // theme: ThemeData(
        //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //       type: BottomNavigationBarType.fixed,
        //       selectedItemColor: defaultColor,
        //       elevation: 20.0),
        //   primarySwatch: Colors.blue,
        //   scaffoldBackgroundColor: Colors.white,
        //   appBarTheme: AppBarTheme(
        //     foregroundColor: Colors.white,
        //     titleSpacing: 20.0,
        //     backwardsCompatibility: false,
        //     systemOverlayStyle: SystemUiOverlayStyle(
        //       statusBarColor: HexColor('#006bff'),
        //       statusBarIconBrightness: Brightness.light,
        //     ),
        //     backgroundColor: HexColor('#006bff'),
        //     elevation: 0.0,
        //     titleTextStyle: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20,
        //     ),
        //     actionsIconTheme: IconThemeData(color: Colors.black),
        //   ),
        //   textTheme: TextTheme(
        //     headline3: TextStyle(
        //       fontSize: 55,
        //       fontFamily: 'f',
        //       fontWeight: FontWeight.w600,
        //       color: Colors.black,
        //     ),
        //     bodyText1: TextStyle(
        //       fontFamily: 'f',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 18,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
