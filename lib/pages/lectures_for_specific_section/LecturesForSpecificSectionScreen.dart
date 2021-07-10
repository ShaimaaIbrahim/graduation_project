import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Section.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/utilities/constants.dart';

import 'Body.dart';

class LecturesForSpecificSectionScreen extends StatelessWidget {
  final Section section;

  const LecturesForSpecificSectionScreen({Key key, this.section})
      : super(key: key);

  void _build(context) {
    Provider.of<DoctorMainScreenProvider>(context, listen: false)
        .getLecturesForSpecificSection(section.section, section.department);
  }

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: Body(),
    );
  }
}
