import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

import 'components/SBody.dart';

class SingleChat extends StatelessWidget {
  final receiver;
  final sender;

  const SingleChat({Key key, this.receiver, this.sender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sender.name,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryLight,
      ),
      backgroundColor: Colors.white,
      body: SBody(
        receiver: receiver,
        sender: sender,
      ),
    );
  }
}
