import 'package:flutter/material.dart';
import 'package:untitled2/model/Doctor.dart';
import 'package:untitled2/utilities/constants.dart';

import 'EBody.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController bioController = TextEditingController();

class EditDoctorProfile extends StatefulWidget {
  final Doctor me;

  const EditDoctorProfile({Key key, this.me}) : super(key: key);

  @override
  _EditDoctorProfileState createState() => _EditDoctorProfileState();
}

class _EditDoctorProfileState extends State<EditDoctorProfile> {
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
      body: EBody(
        me: widget.me,
        nameController: nameController,
        bioController: bioController,
        emailController: emailController,
      ),
    );
  }
}

void _build(BuildContext context, Doctor me) {
  nameController.text = me.name;
  emailController.text = me.email;
  bioController.text = "Hello Every One!!";
}
