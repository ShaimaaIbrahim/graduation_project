import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/Doctor.dart';
import 'package:untitled2/model/Section.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/pages/lectures_for_specific_section/LecturesForSpecificSectionScreen.dart';
import 'package:untitled2/pages/students_for_specific_lecture/StudentsForSpecificLectureScreen.dart';

class DoctorMainScreenProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool visible = false;
  List<Section> _mySections = [];
  List<Section> get mySections => _mySections;

  List<Lecture> _myLectures = [];
  List<Lecture> get myLectures => _myLectures;

  List<Lecture> _myHistoryLectures = [];
  List<Lecture> get myHistoryLectures => _myHistoryLectures;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Doctor? _Me;

  Doctor get Me => _Me!;

  var db = FirebaseFirestore.instance;

  void navigateToLecturesForSpecificSection(
      BuildContext context, Section section) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LecturesForSpecificSectionScreen(
                  section: section,
                )));
  }

  Future<Map<String, dynamic>> getMyInfo() async {
    Doctor? doctor;
    final Map<String, dynamic> result = {'success': false, 'error': null};
    try {
      await db
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                doctor = Doctor(
                  name: value.get('name'),
                  uid: value.get('uid'),
                  email: value.get('email'),
                  password: value.get('password'),
                )
              });

      _Me = doctor!;
      notifyListeners();
    } catch (error) {
      print("failed to get my info --------${error.toString()}");
      result['error'] = error;
    }
    return result;
  }

  /////////////////////////////////////////////////////////////////////////////
  /* get only sections which doctor  teach and appears at main doctor screen */
  Future<Map<String, dynamic>> getOnlyMySections() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<String> sections = [];
    List<Section> mySections = [];

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('lectures')
          .where("doctorId", isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((value) {
        value.docs.forEach((lec) {
          if (!sections.contains(lec.get('section'))) {
            sections.add(lec.get('section'));
            var section = Section(
              checked: false,
              department: lec.get('department'),
              section: lec.get('section'),
            );
            mySections.add(section);
          }
        });
      });

      this._mySections = mySections;
      notifyListeners();

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      _isLoading = false;
      notifyListeners();
      print("catch fetch gone lecturers $error");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /////////////////////////////////////////////////////////////////////////////
  /* get only sections which doctor  teach and appears at main doctor screen */
  Future<Map<String, dynamic>> getLecturesForSpecificSection(
      section, department) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<Lecture> myLectures = [];

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('lectures')
          .where("doctorId", isEqualTo: _auth.currentUser!.uid)
          .where("section", isEqualTo: section)
          .where("department", isEqualTo: department)
          .get()
          .then((value) {
        value.docs.forEach((lec) {
          var lecture = Lecture(
              dateTime: lec.get('dateTime'),
              code: lec.get('code'),
              name: lec.get('name'),
              department: lec.get('department'),
              section: lec.get('section'),
              id: lec.get('id'),
              doctorId: lec.get('doctorId'),
              date: lec.get('date'),
              time: lec.get('time'),
              timeAllowed: lec.get('timeAllowed'),
              timeType: lec.get('timeType'));
          myLectures.add(lecture);
        });
      });

      this._myLectures = myLectures;
      notifyListeners();

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("catch fetch gone lecturers $error");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> storeLectures(dateTime, department, section,
      name, date, time, timeAllowed, timeType) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      print("try to store lecturers");

      DocumentReference snapshot =
          await FirebaseFirestore.instance.collection('lectures').doc();

      var id = snapshot.id;
      result['success'] = true;
      snapshot.set({
        "dateTime": dateTime,
        "code": Random().nextInt(100000).toString(),
        "name": name,
        "date": date,
        "timeAllowed": timeAllowed,
        "timeType": timeType,
        "section": section,
        "department": department,
        "time": time,
        "id": id,
        "doctorId": _auth.currentUser!.uid
      }).catchError((error) {
        result['error'] = error;
        print("error added lecture $error");
      });
      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("error catch add lecture $error");
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> addNotifications(dateTime, department, section,
      name, date, time, timeAllowed, timeType) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      print("try to store lecturers");

      DocumentReference snapshot =
          await FirebaseFirestore.instance.collection('notifications').doc();

      var id = snapshot.id;
      result['success'] = true;
      snapshot.set({
        "dateTime": dateTime,
        "code": Random().nextInt(100000).toString(),
        "name": name,
        "date": date,
        "timeAllowed": timeAllowed,
        "timeType": timeType,
        "section": section,
        "department": department,
        "time": time,
        "id": id,
        "doctorId": _auth.currentUser!.uid
      }).catchError((error) {
        result['error'] = error;
        print("error added notifications $error");
      });
      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("error catch add notifications $error");
    }
    _isLoading = false;

    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getDoctorHistoryLecturers() async {
    List<Lecture> lecturesData = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

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
      _myHistoryLectures = lecturesData;
      notifyListeners();
    } catch (error) {
      print("failed to get lectures --------${error.toString()}");
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  void setChecked(int index, bool val) {
    this.mySections.elementAt(index).checked = val;
    notifyListeners();
    this.checkVisibility();
  }

  void checkVisibility() {
    var count = 0;
    for (int i = 0; i < mySections.length; i++) {
      if (mySections[i].checked == true) {
        this.visible = true;
        notifyListeners();
        break;
      } else if (mySections[i].checked == false) {
        count = count + 1;
      }
    }
    if (count == mySections.length) {
      this.visible = false;
      notifyListeners();
    }
  }

  void deleteSections() async {
    List<Lecture> lectures = [];
    List<Section> sections = [];

    try {
      await FirebaseFirestore.instance
          .collection('lectures')
          .where("doctorId", isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((value) {
        value.docs.forEach((lec) {
          var l = Lecture(
              section: lec.get('section'),
              department: lec.get('department'),
              id: lec.get('id'));
          lectures.add(l);
        });
      });

      mySections.forEach((element) {
        if (element.checked == true) {
          sections.add(element);
        }
      });

      for (int i = 0; i < lectures.length; i++) {
        for (int j = 0; j < sections.length; j++) {
          if (lectures[i].section == sections[j].section) {
            await FirebaseFirestore.instance
                .collection('lectures')
                .doc(lectures[i].id)
                .delete();
          }
        }
      }
      this.getOnlyMySections();
      checkVisibility();
      notifyListeners();
      print("success deleted ===============");
    } catch (e) {
      print("failed deleted $e===============");
    }
  }

  void saveDoctorLocation(context, position) async {
    try {
      await db.collection("doctorLocation").doc(_auth.currentUser!.uid).set({
        "lat": position.latitude,
        "long": position.longitude
      }).whenComplete(() {});

      print("saved location sucessfully --------------");
    } catch (e) {
      print("saved location failed $e --------------");
    }
  }

  void navigateToStudentAbsForLecture(
      BuildContext context, List<Student> all, Lecture lecture) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentsForSpecificLecture(
                  students: all,
                )));
  }
}
