import 'package:flutter/material.dart';
import 'package:sunspark/screens/auth/login_screen.dart';
import 'package:sunspark/screens/auth/user_login.dart';
import 'package:sunspark/screens/pages/track_report.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getHeight(percent) {
      var toDecimal = percent / 100;
      return MediaQuery.of(context).size.height * toDecimal;
    }

    getWidth(percent) {
      var toDecimal = percent / 100;
      return MediaQuery.of(context).size.width * toDecimal;
    }

    showDialogforTrackingReport() async {
      TextEditingController code = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Tracking Code'),
            content: SizedBox(
                height: getHeight(11),
                width: getWidth(100),
                child:
                    TextFieldWidget(label: 'Tracking Code', controller: code)),
            actions: [
              TextButton(
                onPressed: () async {
                  if (code.text.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TrackReportView(
                              documentID: code.text,
                            )));
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: getHeight(2),
              ),
              Image.asset(
                'assets/images/carnab.png',
                height: getHeight(13),
              ),
              TextBold(
                text: 'CARNab',
                fontSize: 24,
                color: Colors.black,
              ),
              TextRegular(
                text: 'Crime and Accident Reporting App of Nabua',
                fontSize: 14,
                color: Colors.grey,
              ),
              SizedBox(
                height: getHeight(2),
              ),
              TextRegular(
                text: 'Login as',
                fontSize: 14,
                color: Colors.black,
              ),
              SizedBox(
                height: getHeight(1),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                inUser: false,
                              )));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/police.jpg',
                          height: getHeight(13),
                        ),
                        SizedBox(
                          height: getHeight(1),
                        ),
                        TextBold(
                          text: 'Police Officer',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getHeight(3),
                  ),
                  TextRegular(
                    text: 'Report as',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: getHeight(2),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserLogin()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/citizen.jpg',
                          height: 100,
                        ),
                        SizedBox(
                          height: getHeight(1),
                        ),
                        TextBold(
                          text: 'Nabua Citizen',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getHeight(2),
                  ),
                  TextRegular(
                    text: 'or',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogforTrackingReport();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/tracking.jpg',
                          height: 100,
                        ),
                        SizedBox(
                          height: getHeight(1),
                        ),
                        TextBold(
                          text: 'Track Report',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// 
