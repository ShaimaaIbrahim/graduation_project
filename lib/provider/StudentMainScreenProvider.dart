import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/Location.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/pages/detection/detection_abscence_page.dart';

class StudentMainScreenProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Location location = Location(lat: 0.0, long: 0.0);

  List<Lecture> _myLectures = [];
  List<Lecture> get myLectures => _myLectures;

  Student _Me = Student(name: "", number: "", section: "");

  Student get Me => _Me;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  var currentDate = DateTime.now();

  Future<Map<String, dynamic>> getMyInfo() async {
    Student student;
    final Map<String, dynamic> result = {'success': false, 'error': null};
    try {
      await db
          .collection('students')
          .doc(_auth.currentUser.uid)
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
      _Me = student;

      print("success to get my info -----------");
    } catch (error) {
      print("failed to get my info --------${error.toString()}");
      result['error'] = error;
    }
  }

  void navigateToAbscenceDetection(context, lecture, cameraDescription) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetectionAbscence(
                  lecture: lecture,
                  cameraDescription: cameraDescription,
                )));
  }

  Future<Map<String, dynamic>> getStudentTodayLecturers() async {
    List<Lecture> lecturesData = [];
    Student student;

    final Map<String, dynamic> result = {'success': false, 'error': null};

    try {
      await db
          .collection('students')
          .doc(_auth.currentUser.uid)
          .get()
          .then((value) => {
                student = Student(
                  section: value.get('section'),
                  department: value.get('department'),
                )
              });

      var lectures = await db
          .collection('lectures')
          .where('section', isEqualTo: student.section)
          .where('department', isEqualTo: student.department)
          .get();

      lectures.docs.forEach((lec) {
        var lecData = Lecture(
          dateTime: lec.get('dateTime'),
          id: lec.get('id'),
          doctorId: lec.get('doctorId'),
          timeAllowed: lec.get('timeAllowed'),
          timeType: lec.get('timeType'),
          department: lec.get("department"),
          section: lec.get('section'),
          name: lec.get('name'),
          code: lec.get('code'),
          date: lec.get('date'),
          time: lec.get('time'),
        );
        if (lecData.dateTime.toDate().day == currentDate.day &&
            lecData.dateTime.toDate().month == currentDate.month) {
          lecturesData.add(lecData);
        }
      });
      _myLectures = lecturesData;

      print("success to get today lectures -----------");
    } catch (error) {
      print("failed to get today lectures --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
  }

  void getDoctorLocation(Lecture lecture) async {
    try {
      await db
          .collection("doctorLocation")
          .doc(lecture.doctorId)
          .get()
          .then((value) {
        this.location =
            Location(long: value.get('long'), lat: value.get('lat'));
      });
      print("success to get location -----------");
    } catch (e) {
      print("failed to get location $e-----------");
    }
  }
}
