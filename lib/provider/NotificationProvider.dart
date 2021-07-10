import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Lecture> _myNotifications = [];
  List<Lecture> get myNotifications => _myNotifications;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  var currentDate = DateTime.now();

  Future<Map<String, dynamic>> getStudentNotifications() async {
    List<Lecture> notificationsData = [];
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
          .collection('notifications')
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
        notificationsData.add(lecData);
      });
      _myNotifications = notificationsData;

      print("success to get notifications -----------");
    } catch (error) {
      print("failed to get notifications --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
  }
}
