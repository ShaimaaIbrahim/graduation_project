import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';

class PrecenceProvider extends ChangeNotifier {
  List<Student> _students = [];
  List<Lecture> _filterLecture = [];
  List<Student> _goneStudents = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Student> get students => _students;

  List<Lecture> get filterLecture => _filterLecture;

  List<Student> get goneStudents => _goneStudents;

  Future<Map<String, dynamic>> getStudentForSpecificSection(Lecture lec) async {
    List<Student> studentsData = [];
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    var student;

    try {
      var students = await FirebaseFirestore.instance
          .collection('students')
          .where("section", isEqualTo: lec.section)
          .where("department", isEqualTo: lec.department)
          .get();

      students.docs.forEach((value) {
        student = Student(
          uid: value.get('uid'),
          section: value.get('section'),
          department: value.get('department'),
          abscence: value.get('abscence'),
          name: value.get('name'),
          number: value.get('number'),
        );
        studentsData.add(student);
      });
      _students = studentsData;
      notifyListeners();
      print("success  getStudentForSpecificSection============");
    } catch (error) {
      result['error'] = error;
      print("get lectures catch error   $error ==");
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getFiteredLecturers(
      String section, String department) async {
    String doctorId = "";

    List<Lecture> lecturesFilter = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('doctorExistence') != null &&
        preferences.getString('doctorId') != null) {
      doctorId = preferences.getString('doctorId')!;

      print("doctor preferences id is $doctorId ");

      try {
        final lects =
            await FirebaseFirestore.instance.collection('lectures').get();

        lects.docs.forEach((lec) {
          if (section == lec.get("section") &&
              department == lec.get("department") &&
              doctorId == lec.get('doctorId')) {
            final lecData = Lecture(
                department: lec.get("department"),
                section: lec.get("section"),
                name: lec.get('name'),
                date: lec.get('date'),
                time: lec.get('time'),
                doctorId: lec.get('doctorId'),
                id: lec.get('id'));

            lecturesFilter.add(lecData);
          }
        });

        _filterLecture = lecturesFilter;
      } catch (error) {
        result['error'] = error;
        print("get filter lectures catch error   $error ==");
      }
    } else {
      print("get filter lectures error   ${result['error']} ==");
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> storeGoneLectures(
      Lecture lec, Student student) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      print("try to store gone lecturers");

      await FirebaseFirestore.instance
          .collection('presence')
          .doc(lec.name! + lec.time!)
          .collection('students')
          .doc()
          .set({
        'name': student.name,
        'section': student.section,
        'number': student.number,
        'department': student.department,
        'uid': student.uid,
        "abscence": true
      });
      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("catch error gone lecturers");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getGoneStudentsLecture(Lecture lec) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<Student> goneStudents = [];

    _isLoading = true;
    notifyListeners();

    try {
      print("try to get store gone lecturers");

      var students = await FirebaseFirestore.instance
          .collection('presence')
          .doc(lec.name! + lec.time!)
          .collection('students')
          .get()
          .catchError((error) {
        result['error'] = error;
        print("error fetch  gone lecturers");
      });

      students.docs.forEach((st) {
        var student = Student(
            uid: st.get('uid'),
            name: st.get('name'),
            section: st.get('section'),
            number: st.get('number'),
            department: st.get('department'),
            abscence: st.get('abscence'));

        goneStudents.add(student);
      });

      _goneStudents = goneStudents;
      notifyListeners();

      print("success getGoneStudentsLecture ============");

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("catch fetch gone lecturers $error");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
