import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/utilities/constants.dart';

class MessageItem extends StatefulWidget {
  final String? senderName;
  final String? senderId;
  final String? text;

  const MessageItem(
      {Key? key,
      required this.senderName,
      required this.senderId,
      required this.text})
      : super(key: key);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  SharedPreferences? preferences;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  String? uid;

  @override
  Widget build(BuildContext context) {
    currentUser = _auth.currentUser;
    uid = currentUser!.uid;

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: widget.senderId == uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(widget.senderName!),
          SizedBox(
            height: 8,
          ),
          Material(
            color:
                widget.senderId == uid ? primaryLight : Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  widget.text!,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
