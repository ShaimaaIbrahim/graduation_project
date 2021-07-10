import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Doctor.dart';
import 'package:untitled2/provider/EditProfileProvider.dart';
import 'package:untitled2/utilities/constants.dart';

EditProfileProvider provider;

class EBody extends StatelessWidget {
  final Doctor me;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController bioController;

  EBody(
      {this.me, this.nameController, this.emailController, this.bioController});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                SizedBox(
                  height: 15,
                ),
                Image.asset(
                  'assets/images/user.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: BuildNameField(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: BuildEmailField(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: BuildBioField(),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      border: Border.all(
                        color: primaryLight,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FlatButton(
                        color: primaryLight,
                        textColor: Colors.white,
                        onPressed: () {
                          Provider.of<EditProfileProvider>(context,
                                  listen: false)
                              .updateDoctorInfo(context, nameController.text,
                                  emailController.text, bioController.text);
                        },
                        child: Text(
                          'update',
                          style: TextStyle(fontSize: 25.0),
                        ))),
              ])),
        ));
  }

  Widget BuildBioField() {
    return TextField(
      controller: bioController,
      decoration: new InputDecoration(
          labelText: 'Add Bio',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.info_outline,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
    );
  }

  Widget BuildNameField() {
    return TextField(
      controller: nameController,
      decoration: new InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.person,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
    );
  }

  Widget BuildEmailField() {
    return TextField(
      controller: emailController,
      decoration: new InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.email,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
    );
  }
}
