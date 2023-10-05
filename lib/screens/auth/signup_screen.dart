import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunspark/screens/auth/login_screen.dart';
import 'package:sunspark/services/signup.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';

import '../../widgets/toast_widget.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/citizen.jpg',
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(label: 'Email', controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    label: 'Password', controller: passwordController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    inputType: TextInputType.number,
                    label: 'Name',
                    controller: nameController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    inputType: TextInputType.number,
                    label: 'Age',
                    controller: ageController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(label: 'Gender', controller: genderController),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    label: 'Address', controller: addressController),
                const SizedBox(
                  height: 50,
                ),
                ButtonWidget(
                  label: 'Register',
                  onPressed: () {
                    register(context);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextRegular(
                      text: 'Already have an account?',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: TextBold(
                        text: 'Login here',
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      addAccount(nameController.text, emailController.text, ageController.text,
          genderController.text, addressController.text);

      showToast("Registered Succesfully!");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
