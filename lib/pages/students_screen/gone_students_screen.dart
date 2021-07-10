import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/utilities/constants.dart';

import 'component/student_list_item.dart';

class GoneStudentsScreen extends StatefulWidget {
  static String routeName = "/students";

  Lecture lecture;

  GoneStudentsScreen({this.lecture});

  @override
  _GoneStudentsScreenState createState() => _GoneStudentsScreenState();
}

class _GoneStudentsScreenState extends State<GoneStudentsScreen> {
  List<Student> goneStudents = [];

  @override
  void initState() {
    Provider.of<PrecenceProvider>(context, listen: false)
        .getGoneStudentsLecture(widget.lecture);

    goneStudents =
        Provider.of<PrecenceProvider>(context, listen: false).goneStudents;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLight,
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<PrecenceProvider>(
        builder: (context, lecData, child) {
          Widget content = Center(
            child: Text('No Students'),
          );
          if (lecData.goneStudents.length > 0) {
            content = ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: goneStudents.length,
              itemBuilder: (BuildContext context, int index) {
                return StudentListItem(
                  student: goneStudents[index],
                  index: index,
                );
              },
            );
          } else if (lecData.isLoading) {
            content = Center(child: CircularProgressIndicator());
          }
          return Container(
            child: content,
          );
        },
      ),
    );
  }
}
