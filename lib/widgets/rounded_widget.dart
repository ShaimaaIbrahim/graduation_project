import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/utilities/constants.dart';

class RoundedWidget extends StatelessWidget {
  final child;
  final icon;

  const RoundedWidget({Key? key, this.icon, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: primaryLight,
          ),
          title: child,
        ));
  }
}
