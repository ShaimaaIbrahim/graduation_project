import 'package:flutter/material.dart';
import 'package:untitled2/pages/doctor_main_screen/Drawer.dart';
import 'package:untitled2/provider/DoctorMainScreenProvider.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'Body.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_location/background_location.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({Key? key}) : super(key: key);

  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _build(context);
    return Consumer<DoctorMainScreenProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'My Sections',
            style: TextStyle(fontSize: 18, color: primaryDark),
          ),
          iconTheme: IconThemeData(color: primaryDark),
          actions: <Widget>[
            Visibility(
              visible: provider.visible,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  provider.deleteSections();
                },
              ),
            ),
          ],
        ),
        body: Body(mainScreenProvider: provider),
        drawer: MyDrawer(),
      );
    });
  }
}

void _build(BuildContext context) async {
  var position1;

  Provider.of<DoctorMainScreenProvider>(context, listen: false)
      .getOnlyMySections();

  Provider.of<DoctorMainScreenProvider>(context, listen: false).getMyInfo();
  Provider.of<StudentProvider>(context, listen: false).getAllStudents();

  BackgroundLocation.startLocationService();
  BackgroundLocation.getLocationUpdates((position) {
    position1 = position;
    print(
        "doctor location is lat: ${position.latitude.toString()} + long: ${position.latitude.toString()}");
  });

  Provider.of<DoctorMainScreenProvider>(context, listen: false)
      .saveDoctorLocation(context, position1);
}
