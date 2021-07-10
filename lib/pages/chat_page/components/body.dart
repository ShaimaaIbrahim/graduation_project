import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/GropMessage.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/provider/ChatProvider.dart';
import 'package:untitled2/utilities/constants.dart';

import 'message_list_item.dart';

TextEditingController messageController = TextEditingController();
ScrollController scrollController = ScrollController();

FirebaseAuth _auth = FirebaseAuth.instance;
String currentDate;
List<GroupMessage> messages;
User currentUser = _auth.currentUser;
String uid = currentUser.uid;

Widget content = Container(
  color: Colors.white,
);
ChatProvider provider = ChatProvider();

class Body extends StatelessWidget {
  final Student me;

  const Body({Key key, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context, provider);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 3,
          ),
          Expanded(
              // ignore: missing_required_param
              child: Consumer<ChatProvider>(
            builder: (context, data, child) {
              provider = data;
              if (data.messages.length > 0) {
                content = ListView.builder(
                  itemCount: data.messages.length,
                  controller: scrollController,
                  itemBuilder: (context, i) {
                    return MessageItem(
                      senderName: data.messages[i].senderName,
                      senderId: data.messages[i].senderId,
                      text: data.messages[i].message,
                    );
                  },
                );
              } else if (data.isLoading) {
                content = Center(
                  child: Container(
                      color: Colors.white, child: CircularProgressIndicator()),
                );
              }
              return RefreshIndicator(
                  onRefresh: data.fetchGroupMessages, child: content);
            },
          )),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Message",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => callback(context, provider),
                )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: primaryLight,
                  onPressed: () async {
                    callback(context, provider);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callback(context, provider) async {
    if (messageController.text.length > 0) {
      provider.addGroupMessage(currentDate, messageController.text, me.uid,
          me.name, me.imagePath, me.section, me.department);
    }

    provider.fetchGroupMessages();

    messageController.clear();

    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
  }
}

void _build(BuildContext context, provider) {
  currentDate = DateTime.now().toIso8601String().toString();
  provider.fetchGroupMessages();
}
