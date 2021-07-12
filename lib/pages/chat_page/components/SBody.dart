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
String? currentDate;
List<GroupMessage>? messages;
User currentUser = _auth.currentUser!;
String uid = currentUser.uid;

Widget content = Container(
  color: Colors.white,
);

class SBody extends StatelessWidget {
  final Student? receiver;
  final Student? sender;

  const SBody({Key? key, required this.receiver, required this.sender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context, sender, receiver);

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
              if (data.singleMessages.length > 0) {
                content = ListView.builder(
                  itemCount: data.singleMessages.length,
                  controller: scrollController,
                  itemBuilder: (context, i) {
                    return MessageItem(
                      senderName: data.singleMessages[i].senderName!,
                      senderId: data.singleMessages[i].senderId!,
                      text: data.singleMessages[i].message!,
                    );
                  },
                );
              } else if (data.isLoading) {
                content = Center(
                  child: Container(
                      color: Colors.white, child: CircularProgressIndicator()),
                );
              }
              return content;
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
                  onSubmitted: (value) => callback(context),
                )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: primaryLight,
                  onPressed: () async {
                    callback(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callback(
    context,
  ) async {
    if (messageController.text.length > 0) {
      Provider.of<ChatProvider>(context, listen: false).addSingleMessage(
          currentDate!,
          messageController.text,
          sender!.uid,
          sender!.name,
          receiver!.uid,
          receiver!.name);
    }
    messageController.clear();

    Provider.of<ChatProvider>(context)
        .fetchSingleMessages(sender!.uid, receiver!.uid);

    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
  }
}

void _build(BuildContext context, sender, receiver) {
  currentDate = DateTime.now().toIso8601String().toString();
  Provider.of<ChatProvider>(context)
      .fetchSingleMessages(sender.uid, receiver.uid);
}
