import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/utilities/constants.dart';

class StudentsForSpecificLecture extends StatelessWidget {
  List<Student>? students;

  StudentsForSpecificLecture({this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All Students',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: students!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(students![index].name!),
                  subtitle: Text(students![index].number!),
                  leading: Image.asset('assets/images/user.png'),
                  trailing: students![index].abscence
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.red,
                        ));
            },
          ),
        ),
      ),
    );
  }
}
