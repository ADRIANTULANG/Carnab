import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunspark/screens/auth/signup_screen.dart';
import 'package:sunspark/screens/mewhome_screen.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';

import '../../widgets/toast_widget.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool? inUser;

  LoginScreen({super.key, this.inUser = true});

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
                'assets/images/police.jpg',
                height: 150,
              ),
              const SizedBox(
                height: 5,
              ),
              TextBold(
                text: 'Police Officer Portal',
                fontSize: 18,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 50,
              ),
              TextFieldWidget(
                  label: inUser! ? 'Email' : 'Username',
                  controller: emailController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  isObscure: true,
                  isPassword: true,
                  label: 'Password',
                  controller: passwordController),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                label: 'Login',
                onPressed: () {
                  login(context);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              inUser!
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'New to Carnab?',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                          },
                          child: TextBold(
                            text: 'Register here',
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  login(context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: inUser!
              ? emailController.text
              : '${emailController.text}@carnab.com',
          password: passwordController.text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NewHomeScreen(
                inUser: inUser,
              )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No user found with that username.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        showToast("Invalid username provided.");
      } else if (e.code == 'user-disabled') {
        showToast("User account has been disabled.");
      } else {
        showToast("An error occurred: ${e.message}");
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
