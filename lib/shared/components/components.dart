// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/styles/Iconly-Broken_icons.dart';

Widget buildTextFormField({
  required validate,
  required context,
  required String text,
  bool obscureText = false,
  required IconData prefix,
  IconData? suffix,
  suffixButton,
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  onTap,
  textInputAction = TextInputAction.done,
  bool isblue = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
    child: TextFormField(
      validator: validate,
      textInputAction: textInputAction,
      obscureText: obscureText,
      keyboardType: type,
      controller: controller,
      onChanged: onChange,
      style: TextStyle(
        color: HexColor('#006bff'),
        fontFamily: '',
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: Transform.translate(
          offset: Offset(-14, 0.0),
          child: Icon(
            prefix,
            size: 22,
          ),
        ),
        hintStyle: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'f'),
        suffixIcon: suffix != null
            ? Transform.translate(
                offset: Offset(10, 0.0),
                child: IconButton(
                  splashRadius: 0.1,
                  onPressed: suffixButton,
                  icon: Icon(
                    suffix,
                    color: isblue ? HexColor('#006bff') : null,
                  ),
                ),
              )
            : null,
      ),
    ),
  );
}

Widget defaultTextButton({
  required onPressed,
  required String text,
  FontWeight fw = FontWeight.normal,
  required context,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15, fontWeight: fw, color: HexColor('#006bff'))),
      style: ButtonStyle(overlayColor: MaterialStateProperty.all(
          // HexColor('#006bff'),
          Colors.blue[100])),
    );

Widget defaultText({
  required context,
  required String text,
  double fs = 14,
  FontWeight fw = FontWeight.normal,
}) =>
    Text(
      text,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 14,
            fontWeight: fw,
          ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
        end: 20.0,
      ),
      child: Container(
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget defaultButton({
  outline = false,
  outlineColor = Colors.grey,
  required String text,
  double height = 40.0,
  bool toUpperCase = false,
  required onPressed,
  reverse = false,
  fontColor,
  bg,
}) =>
    Row(
      children: [
        Expanded(
          child: MaterialButton(
            elevation: 0.0,
            shape: outline
                ? RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: outlineColor),
                    borderRadius: BorderRadius.circular(4),
                  )
                : RoundedRectangleBorder(
                    // side: outline? BorderSide(width: 1, color: Colors.grey) : BorderSide(width: 0),
                    borderRadius: BorderRadius.circular(4),
                  ),
            onPressed: onPressed,
            height: height,
            color: bg != null
                ? bg
                : outline
                    ? Colors.white
                    : HexColor('#006bff'),
            child: Text(
              toUpperCase ? text.toUpperCase() : text,
              style: TextStyle(
                  color: fontColor != null
                      ? fontColor
                      : outline
                          ? Colors.grey.withOpacity(.9)
                          : Colors.white.withOpacity(.9),
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );

void navigatorTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigatorAndFinish(context, widget, {bool previous = true}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => previous,
    );

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    final h = size.height - 30;
    path.lineTo(0, h);

    var firstStart = Offset(size.width / 6 + 60, h - 50);
    var firstEnd = Offset(size.width / 2, h);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - size.width / 6 - 60, h + 50);
    var secondEnd = Offset(size.width, h);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future<bool?> toastShow({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

class defaultAppbar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  var function;
  final leading;

  defaultAppbar(
      {Key? key, this.title, this.actions, this.function, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          IconButton(
            splashRadius: 20,
            onPressed: function,
            icon: Icon(iconBroken.Arrow___Left_2),
          ),
      title: Row(
        children: [
          Text(title ?? ''),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

defaultTagButton({
  required String text,
  required onPressed,
  required context,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: HexColor('#006bff'))),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
