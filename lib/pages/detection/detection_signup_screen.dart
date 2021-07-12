import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' show join;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/database/database.dart';
import 'package:untitled2/pages/student_main_screen/StudentMainScreen.dart';
import 'package:untitled2/services/camera.service.dart';
import 'package:untitled2/services/facenet.service.dart';
import 'package:untitled2/services/ml_vision_service.dart';
import 'package:untitled2/utilities/FacePainter.dart';
import 'package:untitled2/utilities/constants.dart';
import 'package:path/path.dart' as Path;

class DetectionSignUpScreen extends StatefulWidget {
  static String routeName = "/detection";
  final cameraDescription;

  DetectionSignUpScreen({this.cameraDescription});

  @override
  _DetectionSignUpScreenState createState() => _DetectionSignUpScreenState();
}

class _DetectionSignUpScreenState extends State<DetectionSignUpScreen> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future? _initializeControllerFuture;
  bool cameraInitializated = false;

  bool _saving = false;

  // service injection
  MLVisionService _mlVisionService = MLVisionService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();
  DataBaseService _dataBaseService = DataBaseService();

  @override
  void initState() {
    /// starts the camera & start framing faces
    _start();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    ///inintialize ml vision for detection
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _frameFaces();
  }

  /// handles the button pressed event

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          ///process image to convert it to face and frame this face
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces.length > 0) {
            setState(() {
              faceDetected = faces[0];
            });

            /// happens when take image shot with camera , starting image predection
            if (_saving) {
              _faceNetService.setCurrentPrediction(image, faceDetected!);
              List predictedData = _faceNetService.predictedData;

              await _dataBaseService.loadDB();
              await _dataBaseService.saveData(
                  FirebaseAuth.instance.currentUser!.uid, predictedData);

              /// resets the face stored in the face net sevice
              this._faceNetService.setPredictedData(null);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }
          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onShot() async {
      print('onShot performed');

      if (faceDetected == null) {
        return false;
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        //await _cameraService.cameraController.stopImageStream();
        await Future.delayed(Duration(milliseconds: 200));
        XFile file = await _cameraService.cameraController.takePicture();
        imagePath = file.path;
        setState(() {
          _saving = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentMainScreen()),
        );
        setState(() {
          pictureTaked = true;
        });

        return true;
      }
    }

    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (pictureTaked) {
              return Container(
                width: width,
                child: Transform(
                    alignment: Alignment.center,
                    child: Image.file(File(imagePath!)),
                    transform: Matrix4.rotationY(mirror)),
              );
            } else {
              return Container(
                width: width,
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController),
                    CustomPaint(
                      painter:
                          FacePainter(face: faceDetected, imageSize: imageSize),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton.extended(
          elevation: 2.0,
          label: Text('Complete SignUp', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.check),
          backgroundColor: primaryDark,
          onPressed: () async {
            /// on shot action to take picture
            if (faceDetected != null) {
              onShot();
            }
          }),
    );
  }
}
