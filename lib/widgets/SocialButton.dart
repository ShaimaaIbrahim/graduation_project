import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled2/utilities/constants.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.buttonColor,
    required this.text,
    required this.icon,
    required this.onPress,
  }) : super(key: key);
  final Color buttonColor;
  final String text;
  final String icon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 60,
      child: FlatButton(
          color: buttonColor,
          textColor: primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 20,
              ),
              SizedBox(
                width: 20,
              ),
              Text(text.toUpperCase())
            ],
          )),
    );
  }
}
