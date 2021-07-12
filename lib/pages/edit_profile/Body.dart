import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/model/Student.dart';
import 'package:untitled2/provider/EditProfileProvider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'package:untitled2/widgets/rounded_widget.dart';

EditProfileProvider? provider;

class Body extends StatelessWidget {
  final Student me;
  final TextEditingController nameTextFieldValue;
  final TextEditingController numberTextFieldValue;

  Body(
      {required this.me,
      required this.nameTextFieldValue,
      required this.numberTextFieldValue});

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
                  child: BuildNumberField(),
                ),
                Consumer<EditProfileProvider>(builder: (context, data, child) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: DepartmentsDropDown(context, data),
                  );
                }),
                Consumer<EditProfileProvider>(builder: (context, data, child) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: SectionsDropDown(context, data),
                  );
                }),
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
                              .updateStudentInfo(
                            context,
                            nameTextFieldValue.text,
                            numberTextFieldValue.text,
                          );
                        },
                        child: Text(
                          'update',
                          style: TextStyle(fontSize: 25.0),
                        ))),
              ])),
        ));
  }

  Widget DepartmentsDropDown(context, provider) {
    return RoundedWidget(
      icon: Icons.select_all,
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: provider.initialDepartment,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: primaryLight, fontSize: 18),
        onChanged: (String? data) {
          provider.setInitialDepartment(data!);

          if (provider.initialDepartment == departments[0]) {
            provider.setSectionsList(arch_classes);
            provider.setInitialSection(arch_classes[0]);
          } else if (provider.initialDepartment == departments[1]) {
            provider.setSectionsList(electric_classes);
            provider.setInitialSection(electric_classes[0]);
          } else if (provider.initialDepartment == departments[2]) {
            provider.setSectionsList(computer_classes);
            provider.setInitialSection(computer_classes[0]);
          } else {
            provider.setSectionsList(takteet_classes);
            provider.setInitialSection(takteet_classes[0]);
          }
        },
        items: departments.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget SectionsDropDown(context, provider) {
    return RoundedWidget(
      icon: Icons.location_city,
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: provider.initialSection,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: primaryLight, fontSize: 18),
        onChanged: (String? data) {
          provider.setInitialSection(data!);
        },
        items: provider.sections.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget BuildNameField() {
    return TextField(
      controller: nameTextFieldValue,
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

  Widget BuildNumberField() {
    return TextField(
      controller: numberTextFieldValue,
      decoration: new InputDecoration(
          labelText: 'Seat Number',
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
}
