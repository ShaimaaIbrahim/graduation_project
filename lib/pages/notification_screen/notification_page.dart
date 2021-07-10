import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'component/body.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryDark),
      ),
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}
