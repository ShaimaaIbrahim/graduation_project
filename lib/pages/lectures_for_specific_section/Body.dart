import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/lecture.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/provider/Prescence_provider.dart';
import 'package:untitled2/services/excel_service.dart';
import 'package:untitled2/utilities/constants.dart';
import 'package:untitled2/widgets/CardLecture.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorMainScreenProvider>(
        builder: (context, lecData, child) {
      Widget content = Center(
        child: Text('No Lectures'),
      );
      if (lecData.myLectures.length > 0) {
        content = GridView.count(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: List.generate(lecData.myLectures.length, (index) {
              return InkWell(
                onTap: () {
                  Provider.of<PrecenceProvider>(context, listen: false)
                      .getGoneStudentsLecture(lecData.myLectures[index]);

                  Provider.of<PrecenceProvider>(context, listen: false)
                      .getStudentForSpecificSection(lecData.myLectures[index]);

                  storeGoogleSheetStudents(
                      lecData, context, lecData.myLectures[index]);
                },
                child: CardLecture(
                  visible: false,
                  lecture: lecData.myLectures[index],
                ),
              );
            }));
      } else if (lecData.isLoading) {
        content = CircularProgressIndicator();
      }
      return Container(
        color: textOnPrimary,
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: content,
        ),
      );
    });
  }
}

Future<void> storeGoogleSheetStudents(DoctorMainScreenProvider provider,
    BuildContext context, Lecture lec) async {
  Provider.of<PrecenceProvider>(context, listen: false)
      .getGoneStudentsLecture(lec);

  Provider.of<PrecenceProvider>(context, listen: false)
      .getStudentForSpecificSection(lec);

  var gone = Provider.of<PrecenceProvider>(context, listen: false).goneStudents;
  var all = Provider.of<PrecenceProvider>(context, listen: false).students;

  all.forEach((element) {
    if (!gone.contains(element)) {
      gone.add(element);
    }
  });
  all.sort((a, b) => int.parse(a.number!).compareTo(int.parse(b.number!)));
  provider.navigateToStudentAbsForLecture(context, all, lec);

  ExcelService.createNewSheet(all, lec.name! + "_" + lec.section!);
}
