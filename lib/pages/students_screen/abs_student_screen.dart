import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/provider/StudentProvider.dart';

import 'component/student_list_item.dart';

class AbsStudentScreen extends StatefulWidget {
  Lecture lecture;

  AbsStudentScreen({this.lecture});

  @override
  _AbsStudentScreenState createState() => _AbsStudentScreenState();
}

class _AbsStudentScreenState extends State<AbsStudentScreen> {
  List<Student> allStudents = [];
  List<Student> goneStudents = [];
  List<Student> absStudents = [];

  @override
  void initState() {
    Provider.of<PrecenceProvider>(context, listen: false)
        .getGoneStudentsLecture(widget.lecture);

    Provider.of<StudentProvider>(context, listen: false).getAllStudents();

    allStudents =
        Provider.of<StudentProvider>(context, listen: false).allStudents;
    goneStudents =
        Provider.of<PrecenceProvider>(context, listen: false).goneStudents;

    allStudents.forEach((element) {
      if (!goneStudents.contains(element)) {
        absStudents.add(element);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          margin: EdgeInsets.all(10),
          child: Provider.of<StudentProvider>(context, listen: false).isLoading
              ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: absStudents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StudentListItem(
                      student: absStudents[index],
                      index: index,
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
