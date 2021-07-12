import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/pages/chat_page/chat_single_screen.dart';
import 'package:untitled2/provider/StudentMainScreenProvider.dart';

class ColleguesProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Student> _myCollegues = [];

  List<Student> get myCollegues => _myCollegues;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  var currentDate = DateTime.now();

  Future<Map<String, dynamic>> getMyCollegues() async {
    List<Student> myCollegues = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    try {
      var student;
      await db
          .collection('students')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                student = Student(
                    name: value.get('name'),
                    uid: value.get('uid'),
                    email: value.get('email'),
                    number: value.get('number'),
                    password: value.get('password'),
                    section: value.get('section'),
                    department: value.get('department'),
                    abscence: value.get('abscence'))
              });

      var students = await db
          .collection('students')
          .where('section', isEqualTo: student.section)
          .where('department', isEqualTo: student.department)
          .get();
      students.docs.forEach((stud) {
        var std = Student(
          abscence: stud.get('abscence'),
          number: stud.get('number'),
          name: stud.get('name'),
          email: stud.get('email'),
          password: stud.get('password'),
          department: stud.get("department"),
          section: stud.get("section"),
          uid: stud.get('uid'),
        );
        myCollegues.add(std);
      });
      _myCollegues = myCollegues;
    } catch (error) {
      print("failed to get collegues --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  void navigateToSingleChat(Student myCollegu, BuildContext context) {
    Provider.of<StudentMainScreenProvider>(context, listen: false).getMyInfo();
    var sender =
        Provider.of<StudentMainScreenProvider>(context, listen: false).Me;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleChat(
                  receiver: myCollegu,
                  sender: sender,
                )));
  }
}
