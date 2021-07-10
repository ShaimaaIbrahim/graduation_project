import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class CardSection extends StatelessWidget {
  final int index;
  final String section;
  final department;

  const CardSection({Key key, this.index, this.section, this.department})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/exam.png',
                  height: 50,
                  width: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  section.isEmpty ? department : section,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
        Consumer<DoctorMainScreenProvider>(
          builder: (context, provider, child) {
            return Align(
              alignment: Alignment.topLeft,
              child: Positioned(
                left: 10,
                right: 10,
                top: 10,
                child: Checkbox(
                    value: provider.mySections[index].checked,
                    checkColor: primaryDark,
                    activeColor: textOnPrimary,
                    onChanged: (bool val) {
                      provider.setChecked(index, val);
                    }),
              ),
            );
          },
        )
      ],
    );
  }
}
