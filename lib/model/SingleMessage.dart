import 'package:flutter/material.dart';

class SingleMessage {
  String? senderId;
  String? receiverId;
  String? senderName;
  String? receiverName;
  String? message;
  String? date;

  SingleMessage(
      {this.senderId,
      this.receiverId,
      this.senderName,
      this.receiverName,
      this.message,
      this.date});
}
