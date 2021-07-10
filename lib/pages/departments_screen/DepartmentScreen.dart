import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:untitled2/pages/section_screen/components/section_list_item.dart';
import 'package:untitled2/pages/section_screen/section.dart';
import 'package:untitled2/provider/DoctorProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class DepartmentScreen extends StatefulWidget {
  static String routeName = '/department';

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  void initState() {
    Provider.of<DoctorProvider>(context, listen: false).getDoctorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All Departments',
          style: TextStyle(fontSize: 18, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16),
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: departmentsShow.map((e) {
                  return GestureDetector(
                    onTap: () {
                      var index = departmentsShow.indexOf(e, 0);
                      print("index is $index");
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: arch_classes,
                                    department: departmentsShow[0],
                                  )),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: electric_classes,
                                    department: departmentsShow[1],
                                  )),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: computer_classes,
                                    department: departmentsShow[2],
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: takteet_classes,
                                    department: departmentsShow[3],
                                  )),
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            'assets/images/student.png',
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              SectionListItem(sectionName: 'اعدادي هندسة', color: primaryDark),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
