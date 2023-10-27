import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunspark/screens/add_report_page.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';

import 'register_user_screen.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  loginCitizenAccount() async {
    var res = await FirebaseFirestore.instance
        .collection('citizen_user')
        .where('email', isEqualTo: email.text)
        .where('password', isEqualTo: password.text)
        .limit(1)
        .get();
    print(res.docs);
    if (res.docs.length > 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', res.docs[0].id);
      await prefs.setString('email', res.docs[0]['email']);
      await prefs.setString('firstname', res.docs[0]['firstname']);
      await prefs.setString('lastname', res.docs[0]['lastname']);
      await prefs.setString('contactno', res.docs[0]['contactno']);
      await prefs.setString('validID', res.docs[0]['validIDurl']);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddReportPage(
                inUser: true,
              )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account did not exist.'),
      ));
    }
  }

  @override
  void initState() {
    checkIfUserAlreadyLogin();
    super.initState();
  }

  checkIfUserAlreadyLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = await prefs.getString('id');
    if (id != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddReportPage(
                inUser: true,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/citizen.jpg',
                height: 150,
              ),
              const SizedBox(
                height: 5,
              ),
              TextBold(
                text: 'Login as Citizen',
                fontSize: 18,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 50,
              ),
              TextFieldWidget(label: 'Email', controller: email),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  isObscure: true,
                  isPassword: true,
                  label: 'Password',
                  controller: password),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                label: 'Login',
                onPressed: () {
                  loginCitizenAccount();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextRegular(
                text: 'New to Carnab?',
                fontSize: 14,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterUserScreen()));
                    },
                    child: TextBold(
                      text: 'Register here',
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  TextRegular(
                    text: 'or',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddReportPage(
                                inUser: true,
                              )));
                    },
                    child: TextBold(
                      text: 'Report immediately',
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
