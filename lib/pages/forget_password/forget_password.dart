import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/provider/DoctorProvider.dart';
import 'package:untitled2/utilities/constants.dart';

class ForgetPassPage extends StatefulWidget {
  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  String emailTextField;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/student.png',
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: BuildEmail(),
              ),
              SizedBox(
                height: 15,
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
                      onPressed: () async {
                        await Provider.of<DoctorProvider>(context,
                                listen: false)
                            .sendEmailForResetPassword(
                                emailTextField.toString());
                      },
                      child: Text(
                        'Send Reset Password Link',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildEmail() {
    return TextField(
      decoration: new InputDecoration(
          labelText: 'Email',
          hintText: 'Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.email,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
      onChanged: (value) {
        emailTextField = value;
      },
    );
  }
}
