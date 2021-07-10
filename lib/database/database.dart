import 'dart:convert';
import 'dart:io';

class DataBaseService {
  DataBaseService._internal();

  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }

  File jsonFile;

  Map<String, dynamic> _db = Map<String, dynamic>();

  Map<String, dynamic> get db => this._db;

  Future loadDB() async {
    print("start load db =================================");

    var tempDir = Directory("storage/emulated/0/" + DateTime.now().toString());
    String _embPath = tempDir.path + '/emb.json';

    jsonFile = new File(_embPath);

    if (jsonFile.existsSync()) {
      _db = json.decode(jsonFile.readAsStringSync());
    }
  }

  Future saveData(String userId, List modelData) async {
    print("start save data at database class =============================");

    _db[userId] = modelData;

    jsonFile.writeAsStringSync(json.encode(_db));

    print("_db[userId] is $modelData ======================================");
  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    jsonFile.writeAsStringSync(json.encode({}));
  }
}
