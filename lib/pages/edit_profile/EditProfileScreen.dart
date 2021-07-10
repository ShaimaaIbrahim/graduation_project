import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/provider/EditProfileProvider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'Body.dart';

TextEditingController nameTextFieldValue = TextEditingController();
TextEditingController numberTextFieldValue = TextEditingController();

class EditProfileScreen extends StatefulWidget {
  final Student me;

  const EditProfileScreen({Key key, this.me}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void didChangeDependencies() {
    _build(context, widget.me);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: Body(
          me: widget.me,
          nameTextFieldValue: nameTextFieldValue,
          numberTextFieldValue: numberTextFieldValue),
    );
  }
}

void _build(BuildContext context, Student me) {
  nameTextFieldValue.text = me.name;
  numberTextFieldValue.text = me.number;

  Provider.of<EditProfileProvider>(context, listen: false).initialDepartment =
      me.department;

  if (Provider.of<EditProfileProvider>(context, listen: false)
          .initialDepartment ==
      departments[0]) {
    Provider.of<EditProfileProvider>(context, listen: false)
        .setSectionsList(arch_classes);
  } else if (Provider.of<EditProfileProvider>(context, listen: false)
          .initialDepartment ==
      departments[1]) {
    Provider.of<EditProfileProvider>(context, listen: false)
        .setSectionsList(electric_classes);
  } else if (Provider.of<EditProfileProvider>(context, listen: false)
          .initialDepartment ==
      departments[2]) {
    Provider.of<EditProfileProvider>(context, listen: false)
        .setSectionsList(computer_classes);
  } else {
    Provider.of<EditProfileProvider>(context, listen: false)
        .setSectionsList(takteet_classes);
  }
  Provider.of<EditProfileProvider>(context, listen: false).initialSection =
      me.section;
}
