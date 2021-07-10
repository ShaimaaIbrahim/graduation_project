import 'package:flutter/material.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/utilities/constants.dart';
import 'components/body.dart';

class GroupChat extends StatelessWidget {
  final Student me;

  const GroupChat({Key key, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'One Section GroupChat',
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryLight,
      ),
      backgroundColor: Colors.white,
      body: Body(me: me),
    );
  }
}
