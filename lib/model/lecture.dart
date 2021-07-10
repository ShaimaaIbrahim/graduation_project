import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  Timestamp dateTime;
  String name;
  String department;
  String section;
  String time;
  String date;
  String id;
  String doctorId;
  String timeAllowed;
  String timeType;
  String code;

  Lecture(
      {this.dateTime,
      this.name,
      this.timeAllowed,
      this.timeType,
      this.department,
      this.section,
      this.time,
      this.date,
      this.code,
      this.doctorId,
      this.id});
}
