import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/model/GropMessage.dart';
import 'package:untitled2/model/SingleMessage.dart';
import 'package:untitled2/model/Student.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<GroupMessage> _messages = [];

  bool get isLoading => _isLoading;
  List<GroupMessage> get messages => _messages;

  var db = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;

  List<SingleMessage> _singleMessages = [];
  List<SingleMessage> get singleMessages => _singleMessages;

  Future<Map<String, dynamic>> fetchGroupMessages() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    List<GroupMessage> messagesList = [];

    Student? student;

    try {
      await db
          .collection('students')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                student = Student(
                  section: value.get('section'),
                  department: value.get('department'),
                  abscence: false,
                )
              });
      var snapshot = await db
          .collection('messages')
          .where("senderSection", isEqualTo: student!.section)
          .where("senderDepartment", isEqualTo: student!.department)
          .get()
          .catchError((error) {
        result['error'] = error;
      });

      snapshot.docs.forEach((value) {
        var mes = GroupMessage(
          date: value.get('date'),
          message: value.get('message'),
          senderId: value.get('senderId'),
          senderName: value.get('senderName'),
          senderSection: value.get('senderSection'),
          senderDepartment: value.get('senderDepartment'),
        );

        messagesList.add(mes);
      });

      result['success'] = true;
      _messages = messagesList;

      print("success get messages  ===========00000000000000000");
    } catch (error) {
      result['error'] = error;
      print("catch error get messages  $error");
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> addGroupMessage(String date, String message, uid,
      name, image, section, department) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc()
          .set({
            "date": date,
            "message": message,
            "senderId": uid,
            "senderName": name,
            "senderSection": section,
            "senderDepartment": department
          })
          .then((value) => {result['success'] = true})
          .catchError((_) {
            result['error'] = _;
          });
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> addSingleMessage(String date, String message,
      senderId, senderName, receiverId, receiverName) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc()
          .set({
            "date": date,
            "message": message,
            "senderId": senderId,
            "senderName": senderName,
            "receiverId": receiverId,
            "receiverName": receiverName,
          })
          .then((value) => {result['success'] = true})
          .catchError((_) {
            result['error'] = _;
          });
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> fetchSingleMessages(senderId, receiverId) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    List<SingleMessage> messagesList = [];
    Student? student;
    try {
      await db
          .collection('students')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                student = Student(
                  section: value.get('section'),
                  department: value.get('department'),
                  abscence: false,
                )
              });
      var snapshot = await db.collection('chats').get().catchError((error) {
        result['error'] = error;
      });

      snapshot.docs.forEach((value) {
        var mes = SingleMessage(
            date: value.get('date'),
            message: value.get('message'),
            senderId: value.get('senderId'),
            senderName: value.get('senderName'),
            receiverId: value.get('receiverId'),
            receiverName: value.get('receiverName'));

        if ((value.get('senderId') == senderId &&
                value.get('receiverId') == receiverId) ||
            value.get('senderId') == receiverId &&
                value.get('receiverId') == senderId) {
          messagesList.add(mes);
        }
      });

      result['success'] = true;
      _singleMessages = messagesList;
      notifyListeners();

      print("success get messages  ===========00000000000000000");
    } catch (error) {
      result['error'] = error;
      print("catch error get messages  $error");
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
