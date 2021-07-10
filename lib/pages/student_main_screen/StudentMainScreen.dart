import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

import 'Body.dart';
import 'MyDrawer.dart';

class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Lectures Today',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: Body(),
      drawer: MyDrawer(),
    );
  }
}
