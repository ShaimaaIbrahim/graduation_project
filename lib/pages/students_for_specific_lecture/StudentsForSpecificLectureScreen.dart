import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/utilities/constants.dart';

ScreenshotController screenshotController = ScreenshotController();

class StudentsForSpecificLecture extends StatelessWidget {
  List<Student> students;

  StudentsForSpecificLecture({this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All Students',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.green,
            ),
            onPressed: () {
              // provider.deleteSections();
            },
          ),
        ],
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Container(
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    takeScreenShotAndSaveItAsPdf();
                  },
                  child: ListTile(
                      title: Text(students[index].name),
                      subtitle: Text(students[index].number),
                      leading: Image.asset('assets/images/user.png'),
                      trailing: students[index].abscence
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void takeScreenShotAndSaveItAsPdf() async {
  var _imageFile;
  screenshotController.capture().then((Uint8List image) {
    _imageFile = image;
  }).catchError((onError) {
    print(onError);
  });

  /*final image = pdf.MemoryImage(
    _imageFile.readAsBytesSync(),
  );
*/
/*  pdf.addPage(pdf.Page(build: (pw.Context context) {
    return pdf.Center(
      child: pw.Image(image),
    ); // Center
  }));

  final file = File("");
  await file.writeAsBytes(await pdf.save());*/
}
