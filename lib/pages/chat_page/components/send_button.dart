import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  SendButton({required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: primaryLight,
      onPressed: callback,
      icon: Icon(Icons.send),
    );
  }
}
