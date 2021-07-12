import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

import 'EBody.dart';

class DoctorHistoryScreen extends StatelessWidget {
  const DoctorHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My History',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: EBody(),
    );
  }
}
