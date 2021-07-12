import 'dart:convert';
import 'dart:io';
import 'package:untitled2/utilities/constants.dart';

class DataBaseService {
  DataBaseService._internal();

  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }

  File? jsonFile;

  Map<String, dynamic> _db = Map<String, dynamic>();

  Map<String, dynamic> get db => this._db;

  loadDB() async {
    print("start load db =================================");
    jsonFile = new File(PATH + "emb.json");
    if (jsonFile!.existsSync()) {
      _db = json.decode(jsonFile!.readAsStringSync());
    }
  }

  Future saveData(String userId, List modelData) async {
    print("start save data at database class =======================");
    _db[userId] = modelData;

    jsonFile!.writeAsStringSync(json.encode(_db));

    print("_db[userId] is $modelData ================================");
  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    jsonFile!.writeAsStringSync(json.encode({}));
  }
}
