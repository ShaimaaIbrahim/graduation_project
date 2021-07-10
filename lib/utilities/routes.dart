import 'package:flutter/cupertino.dart';
import 'package:untitled2/pages/add_lecture_screen/add_lecture.dart';
import 'package:untitled2/pages/all_doctors/all_lecturers.dart';
import 'package:untitled2/pages/departments_screen/DepartmentScreen.dart';
import 'package:untitled2/pages/detection/detection_signup_screen.dart';
import 'package:untitled2/pages/intro_screen/intro_screen_component.dart';
import 'package:untitled2/pages/splash_screen/splash_page.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (BuildContext context) => SplashScreen(),
  IntroScreen.routeName: (BuildContext) => IntroScreen(),
  DepartmentScreen.routeName: (BuildContext context) => DepartmentScreen(),
  AddLectureScreen.routeName: (BuildContext context) => AddLectureScreen(),
  DetectionSignUpScreen.routeName: (BuildContext context) =>
      DetectionSignUpScreen(),
  AllDoctors.routeName: (BuildContext context) => AllDoctors(),
};
