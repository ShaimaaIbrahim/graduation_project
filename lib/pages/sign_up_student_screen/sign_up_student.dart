import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/pages/detection/detection_signup_screen.dart';
import 'package:untitled2/pages/log_in_screen/log_in.dart';
import 'package:untitled2/provider/StudentProvider.dart';
import 'package:untitled2/utilities/constants.dart';
import 'package:untitled2/widgets/rounded_widget.dart';

/**
 * created by shaimaa salama
 */

class StudentSignUp extends StatefulWidget {
  static String routeName = '/student';

  @override
  _StudentSignUpState createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  CameraDescription cameraDescription;

  bool isShown1 = true;
  bool isShown2 = true;

  /// for dropdown menu
  String initialDepartment = departments[0];
  String initialSection = arch_classes[0];
  List<String> sections = arch_classes;

  String nameTextFieldValue;
  String emailTexttFieldValue;
  String passwordTextFieldValue;
  String numberTextFieldValue;
  String confirmPasswordTextFieldValue;

  Future<void> submit() async {
    if (nameTextFieldValue.isEmpty ||
        emailTexttFieldValue.isEmpty ||
        passwordTextFieldValue.isEmpty ||
        confirmPasswordTextFieldValue.isEmpty ||
        numberTextFieldValue.isEmpty) {
      _showMyDialog('Not Leave Empty Fields');
    } else if (nameTextFieldValue.isNotEmpty &&
        emailTexttFieldValue.isNotEmpty &&
        passwordTextFieldValue.isNotEmpty &&
        confirmPasswordTextFieldValue.isNotEmpty &&
        numberTextFieldValue.isNotEmpty) {
      if (passwordTextFieldValue != confirmPasswordTextFieldValue) {
        _showMyDialog('Confirmed Password is Wrong--');
      } else {
        final result =
            await Provider.of<StudentProvider>(context, listen: false).signUp(
          name: nameTextFieldValue.toString(),
          email: emailTexttFieldValue.toString().trim(),
          password: passwordTextFieldValue.toString(),
          number: numberTextFieldValue.toString(),
          department: initialDepartment,
          section: initialSection,
          abscence: false,
        );

        if (result['success']) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetectionSignUpScreen(
                        cameraDescription: cameraDescription,
                      )));
        } else {
          if (result['error'].toString().contains(kNetworkFieldCond)) {
            _showMyDialog('kNetworkFieldMessage');
          } else {
            _showMyDialog(result['error'].toString());
          }
        }
      }
    }
  }

  Future<void> _showMyDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  _startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Image(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  image: AssetImage('assets/images/student.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign Up As Student',
                  style: TextStyle(fontSize: 20, color: primaryDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(padding: const EdgeInsets.all(8.0), child: BuildName()),
                Padding(
                    padding: const EdgeInsets.all(8.0), child: BuildEmail()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildNumberField()),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: RoundedWidget(
                    icon: Icons.account_circle,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: initialDepartment,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      onChanged: (String data) {
                        setState(() {
                          initialDepartment = data;
                          if (initialDepartment == departments[0]) {
                            sections = arch_classes;
                            initialSection = arch_classes[0];
                          } else if (initialDepartment == departments[1]) {
                            sections = electric_classes;
                            initialSection = electric_classes[0];
                          } else if (initialDepartment == departments[2]) {
                            sections = computer_classes;
                            initialSection = computer_classes[0];
                          } else if (initialDepartment == departments[3]) {
                            sections = takteet_classes;
                            initialSection = takteet_classes[0];
                          } else {
                            initialSection = "";
                            sections = [];
                          }
                        });
                      },
                      items: departments
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: RoundedWidget(
                    icon: Icons.add,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: initialSection,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      onChanged: (String data) {
                        setState(() {
                          initialSection = data;
                        });
                      },
                      items: sections
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildPasswordField()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildConfirmPasswordField()),
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
                          /// complete signup using image processing
                          submit();
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(fontSize: 25.0),
                        ))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Already Have an Account ?'),
                    SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen(
                                        log: 2,
                                      )));
                        },
                        child: Text(
                          'LogIn',
                          style: TextStyle(color: primaryDark),
                        )),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack buildDividerOr() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Positioned(
          left: 10,
          right: 10,
          bottom: 0,
          top: 0,
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 60,
            height: 40,
            color: Colors.white,
            child: Center(
                child: Text(
              "OR",
              style: TextStyle(color: Colors.black),
            )),
          ),
        ),
      ],
    );
  }

  Widget BuildEmail() {
    return TextField(
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
      onChanged: (value) {
        emailTexttFieldValue = value;
      },
    );
  }

  Widget BuildName() {
    return TextField(
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
      onChanged: (value) {
        nameTextFieldValue = value;
      },
    );
  }

  Widget BuildNumberField() {
    return TextField(
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
      onChanged: (value) {
        numberTextFieldValue = value;
      },
    );
  }

  Widget BuildPasswordField() {
    return TextField(
      obscureText: isShown1,
      decoration: InputDecoration(
        hintText: 'password',
        prefixIcon: Icon(
          Icons.lock,
          color: primaryLight,
        ),
        border: OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(isShown1 ? Icons.visibility_off : Icons.visibility),
          onPressed: showOrHide1,
        ),
      ),
      onChanged: (value) {
        passwordTextFieldValue = value;
      },
    );
  }

  Widget BuildConfirmPasswordField() {
    return TextField(
      obscureText: isShown2,
      decoration: InputDecoration(
        hintText: 'confirm password',
        prefixIcon: Icon(
          Icons.lock,
          color: primaryLight,
        ),
        border: OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(isShown2 ? Icons.visibility_off : Icons.visibility),
          onPressed: showOrHide2,
        ),
      ),
      onChanged: (value) {
        confirmPasswordTextFieldValue = value;
      },
    );
  }

  showOrHide1() {
    setState(() {
      isShown1 = !isShown1;
    });
  }

  showOrHide2() {
    setState(() {
      isShown2 = !isShown2;
    });
  }
}
