import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/utilities/constants.dart';

class CardLecture extends StatelessWidget {
  final Lecture lecture;
  final bool visible;

  const CardLecture({Key key, this.lecture, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/exam.png',
                  height: 50,
                  width: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  lecture.name,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  lecture.date,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  lecture.time,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            )),
        Visibility(
          visible: visible,
          child: Align(
            alignment: Alignment.topLeft,
            child: Positioned(
              left: 10,
              right: 10,
              top: 10,
              child: Checkbox(
                  value: false,
                  checkColor: primaryDark,
                  activeColor: textOnPrimary,
                  onChanged: (bool val) {}),
            ),
          ),
        )
      ],
    );
  }
}
