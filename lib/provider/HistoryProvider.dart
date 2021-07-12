import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';

class HistoryProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Lecture> _myHistoryLectures = [];
  List<Lecture> get myHistoryLectures => _myHistoryLectures;

  List<Lecture> _docHistoryLectures = [];
  List<Lecture> get docHistoryLectures => _docHistoryLectures;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  var currentDate = DateTime.now();

  Future<void> getStudentHistoryLecturers() async {
    List<Lecture> lecturesData = [];
    Student? student;

    final Map<String, dynamic> result = {'success': false, 'error': null};

    try {
      await db
          .collection('students')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                student = Student(
                  section: value.get('section'),
                  department: value.get('department'),
                  abscence: false,
                )
              });

      var lectures = await db
          .collection('lectures')
          .where('section', isEqualTo: student!.section!)
          .where('department', isEqualTo: student!.department!)
          .get();
      lectures.docs.forEach((lec) {
        var lecData = Lecture(
          dateTime: lec.get('dateTime'),
          id: lec.get('id'),
          doctorId: lec.get('doctorId'),
          timeAllowed: lec.get('timeAllowed'),
          timeType: lec.get('timeType'),
          department: lec.get('department'),
          section: lec.get('section'),
          name: lec.get('name'),
          code: lec.get('code'),
          date: lec.get('date'),
          time: lec.get('time'),
        );
        lecturesData.add(lecData);
      });
      _myHistoryLectures = lecturesData;

      print("success to get lectures -----------");
    } catch (error) {
      print("failed to get lectures --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDoctorHistoryLecturers() async {
    List<Lecture> lecturesData = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    try {
      var lectures = await db
          .collection('lectures')
          .where('doctorId', isEqualTo: _auth.currentUser!.uid)
          .get();

      lectures.docs.forEach((lec) {
        var lecData = Lecture(
          dateTime: lec.get('dateTime'),
          id: lec.get('id'),
          doctorId: lec.get('doctorId'),
          timeAllowed: lec.get('timeAllowed'),
          timeType: lec.get('timeType'),
          department: lec.get('department'),
          section: lec.get('section'),
          name: lec.get('name'),
          code: lec.get('code'),
          date: lec.get('date'),
          time: lec.get('time'),
        );
        lecturesData.add(lecData);
      });
      _docHistoryLectures = lecturesData;
      print("success to get lectures -----------");
    } catch (error) {
      print("failed to get lectures --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
  }
}
