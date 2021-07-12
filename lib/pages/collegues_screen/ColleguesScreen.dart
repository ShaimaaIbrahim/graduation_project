import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

import 'Body.dart';

class ColleguesScreen extends StatelessWidget {
  const ColleguesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Collegues',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: Body(),
    );
  }
}
