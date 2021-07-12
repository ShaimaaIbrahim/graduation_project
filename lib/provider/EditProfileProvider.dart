import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled2/utilities/constants.dart';

class EditProfileProvider extends ChangeNotifier {
  String initialDepartment = departments[0];
  String initialSection = arch_classes[0];
  List<String> sections = arch_classes;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  var currentDate = DateTime.now();

  void setInitialDepartment(String department) {
    this.initialDepartment = department;
    notifyListeners();
  }

  void setInitialSection(String section) {
    this.initialSection = section;
    notifyListeners();
  }

  void setSectionsList(List<String> sections) {
    this.sections = sections;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateStudentInfo(
      BuildContext context, String name, String number) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    try {
      await db.collection('students').doc(_auth.currentUser!.uid).update({
        "name": name,
        "number": number,
        "section": this.initialSection,
        "department": this.initialDepartment
      });
      result['success'] = true;
      Navigator.pop(context);
    } catch (error) {
      result['error'] = error;
    }
    return result;
  }

  void updateDoctorInfo(
      BuildContext context, String name, String email, String bio) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    try {
      await db.collection('doctors').doc(_auth.currentUser!.uid).update({
        "name": name,
        "email": email,
      });
      result['success'] = true;
      Navigator.pop(context);
    } catch (error) {
      result['error'] = error;
    }
  }
}
