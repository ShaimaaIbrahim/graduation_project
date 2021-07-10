import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Location.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/pages/detection/detection_abscence_page.dart';
import 'package:untitled2/provider/ChatProvider.dart';
import 'package:untitled2/provider/StudentMainScreenProvider.dart';
import 'package:untitled2/widgets/CardLecture.dart';

CameraDescription cameraDescription;

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _startUp(context);
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: SingleChildScrollView(
        child: Consumer<StudentMainScreenProvider>(
          builder: (context, mainScreenProvider, child) {
            Widget content = Center(
              child: Text('No Lectures Today'),
            );

            if (mainScreenProvider.myLectures.length > 0) {
              content = Container(
                child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(
                        mainScreenProvider.myLectures.length, (index) {
                      return InkWell(
                        onTap: () {
                          checkEntryToLecture(
                              context, mainScreenProvider.myLectures[index]);
                        },
                        child: CardLecture(
                          visible: false,
                          lecture: mainScreenProvider.myLectures[index],
                        ),
                      );
                    })),
              );
            } else if (mainScreenProvider.isLoading) {
              content =
                  Container(child: Center(child: CircularProgressIndicator()));
            }
            return RefreshIndicator(
                onRefresh: mainScreenProvider.getStudentTodayLecturers,
                child: content);
          },
        ),
      ),
    );
  }
}

Future<void> _showAddCodeDialoge(context, String text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Warning---'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(text)],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('cancel'),
          ),
        ],
      );
    },
  );
}

void checkEntryToLecture(context, Lecture lecture) {
  var currentTime = Timestamp.now().toDate();
  DateTime addedDuration;

  if (lecture.timeType == "ساعة") {
    addedDuration =
        currentTime.add(Duration(hours: int.parse(lecture.timeAllowed.trim())));
  } else {
    addedDuration = currentTime
        .add(Duration(minutes: int.parse(lecture.timeAllowed.trim())));
  }

  var distance = 3.0;
  _getDistance(context, lecture).then((val) {
    distance = val;
  });

  if (distance <= 2.0) {
    if ((currentTime.isAfter(lecture.dateTime.toDate()) &&
            currentTime.isBefore(addedDuration)) ||
        currentTime == lecture.dateTime.toDate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DetectionAbscence(
                    cameraDescription: cameraDescription,
                    lecture: lecture,
                  )));
    } else {
      _showAddCodeDialoge(context, "this time is not time for lecture");
    }
  } else {
    _showAddCodeDialoge(context, "You are in incorrect location");
  }
}

_startUp(BuildContext context) async {
  Provider.of<StudentMainScreenProvider>(context, listen: false)
      .getStudentTodayLecturers();

  Provider.of<ChatProvider>(context, listen: false).fetchGroupMessages();

  List<CameraDescription> cameras = await availableCameras();

  /// takes the front camera
  cameraDescription = cameras.firstWhere(
    (CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front,
  );
}

Future<double> _getDistance(BuildContext context, Lecture lecture) async {
  var studentLocation = await GeolocatorPlatform.instance
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  Provider.of<StudentMainScreenProvider>(context).getDoctorLocation(lecture);

  Location doctorLocation =
      Provider.of<StudentMainScreenProvider>(context).location;

  double _distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
      studentLocation.latitude,
      studentLocation.longitude,
      doctorLocation.lat,
      doctorLocation.long);

  return _distanceInMeters;
}
