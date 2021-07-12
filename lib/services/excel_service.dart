import 'dart:io';
import 'package:path/path.dart';
import 'package:untitled2/model/Student.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:untitled2/utilities/constants.dart';

class ExcelService {
  static void createNewSheet(List<Student> students, String lectureName) async {
    try {
      var excel = Excel.createExcel(); //create an excel sheet

      excel.delete(lectureName);

      Sheet sheetObject = excel[lectureName];

      sheetObject.appendRow(["name", "number", "abscence"]);

      for (int i = 0; i < students.length; i++) {
        var absecence = "";
        if (students[i].abscence == true) {
          absecence = "abscence";
        } else {
          absecence = "not abscence";
        }
        sheetObject
            .appendRow([students[i].name!, students[i].number!, absecence]);
/*
        var name = sheetObject.cell(CellIndex.indexByString(
            "A${i + 1}")); //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
        name.value =  + "okkk";

        var number = sheetObject.cell(CellIndex.indexByString(
            "B${i + 1}")); //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
        number.value = ;

        var abscence = sheetObject.cell(CellIndex.indexByString(
            "C${i + 1}")); //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...*/

      }

      excel.encode().then((onValue) {
        File(PATH + lectureName + ".xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
    } catch (e) {
      print("error store at excel $e");
    }
  }
}
