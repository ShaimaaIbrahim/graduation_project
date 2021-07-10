import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/database/database.dart';
import 'package:untitled2/pages/doctor_main_screen/DoctorMainScreen.dart';
import 'package:untitled2/pages/intro_screen/intro_screen_component.dart';
import 'package:untitled2/pages/student_main_screen/StudentMainScreen.dart';
import 'package:untitled2/provider/DoctorProvider.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/services/facenet.service.dart';
import 'package:untitled2/services/ml_vision_service.dart';
import 'package:untitled2/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = true;

  bool _isAuthenticated1 = false;
  bool _isAuthenticated2 = false;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  _startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    print(
        "modelbd is ${_dataBaseService.db}===================================");
    await _mlVisionService.initialize();

    sleep(Duration(seconds: 10));

    Provider.of<StudentProvider>(context, listen: false).autoAuthenticated();
    Provider.of<DoctorProvider>(context, listen: false).autoAuthenticated();

    _isAuthenticated1 =
        Provider.of<StudentProvider>(context, listen: false).isAuthenticated;

    _isAuthenticated2 =
        Provider.of<DoctorProvider>(context, listen: false).isAuthenticated;

    if (_isAuthenticated1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentMainScreen()),
      );
    } else if (_isAuthenticated2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorMainScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryLight, //or set color with: Color(0xFF0000FF)
    ));

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: primaryLight,
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                'Attendance System',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/student.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
