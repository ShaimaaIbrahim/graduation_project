import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/pages/add_lecture_screen/add_lecture.dart';
import 'package:untitled2/pages/departments_screen/DepartmentScreen.dart';
import 'package:untitled2/pages/edit_profile/EditDoctorProfile.dart';
import 'package:untitled2/pages/history_screen/DoctorHistoryScreen.dart';
import 'package:untitled2/pages/intro_screen/intro_screen_component.dart';
import 'package:untitled2/pages/search_students/search_students.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/provider/DoctorProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Consumer<DoctorMainScreenProvider>(
      builder: (context, provider, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: primaryLight),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(provider.Me.name!),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditDoctorProfile(
                                me: provider.Me,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Lecture'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddLectureScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.filter_list),
                title: Text('Filter Lectures'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.business),
                title: Text('All Departments'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DepartmentScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('My History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorHistoryScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Students'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchStudents()));
                },
              ),
              ListTile(
                leading: Icon(Icons.forward),
                title: Text('LogOut'),
                onTap: () {
                  Provider.of<DoctorProvider>(context).signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => IntroScreen()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void _build(BuildContext context) {
  Provider.of<DoctorMainScreenProvider>(context).getMyInfo();
}
