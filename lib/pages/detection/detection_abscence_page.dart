import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' show join;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/database/database.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/services/camera.service.dart';
import 'package:untitled2/services/facenet.service.dart';
import 'package:untitled2/services/ml_vision_service.dart';
import 'package:untitled2/utilities/FacePainter.dart';
import 'package:path/path.dart' as Path;
import 'package:untitled2/utilities/constants.dart';

class DetectionAbscence extends StatefulWidget {
  final Lecture? lecture;
  final CameraDescription? cameraDescription;

  const DetectionAbscence({Key? key, this.cameraDescription, this.lecture})
      : super(key: key);

  @override
  _DetectionAbscenceState createState() => _DetectionAbscenceState();
}

class _DetectionAbscenceState extends State<DetectionAbscence> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();
  DataBaseService _dataBaseService = DataBaseService();

  Future? _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;

  String? imagePath;
  Size? imageSize;
  Face? faceDetected;
  SharedPreferences? preferences;
  BuildContext? mContext;

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
        _cameraService.startService(widget.cameraDescription!);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    await _dataBaseService.loadDB();
    await _faceNetService.loadModel();
    _mlVisionService.initialize();

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              setState(() {
                faceDetected = faces[0];
              });

              if (_saving) {
                _faceNetService.setCurrentPrediction(image, faceDetected!);
                var userId = _faceNetService.predict();

                print("saving camera userId is $userId");

                await Provider.of<StudentProvider>(mContext!, listen: false)
                    .getStudentInfo();

                var student =
                    Provider.of<StudentProvider>(mContext!, listen: false)
                        .student;

                await Provider.of<PrecenceProvider>(mContext!, listen: false)
                    .storeGoneLectures(widget.lecture!, student);

                Navigator.pop(mContext!);

                setState(() {
                  _saving = false;
                });
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }
          _detectingFaces = false;
        } catch (e) {
          print("catch frame faces error is $e");
          _detectingFaces = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.mContext = context;

    Future<void> onShot() async {
      if (faceDetected == null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('No face detected!'),
              );
            });
        return;
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        //await _cameraService.cameraController.stopImageStream();
        await Future.delayed(Duration(milliseconds: 200));
        XFile file = await _cameraService.cameraController.takePicture();
        imagePath = file.path;
        setState(() {
          _saving = true;
        });
        Navigator.pop(context);
        setState(() {
          pictureTaked = true;
        });

        return;
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
                height: height,
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
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.check),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () async {
            onShot();
          }),
    );
  }
}
