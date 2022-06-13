import 'package:flutter/material.dart';
import 'package:social_app/shared/components/components.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppbar(title: 'Comments', function: () {
        Navigator.pop(context);
      }),
      body: Center(
        child: Text('Comments'),
      ),
    );
  }
}
