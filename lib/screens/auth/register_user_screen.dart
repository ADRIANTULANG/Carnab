import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';
import 'package:email_validator/email_validator.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController retypepassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController contactno = TextEditingController();
  UploadTask? uploadTask;
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  XFile? photo;

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  onchangedTextEditingController() async {
    if (contactno.text.length == 0) {
    } else {
      if (contactno.text[0] != "9" || contactno.text.length > 10) {
        contactno.clear();
      } else {}
    }
  }

  getImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        photo = image;
      });
    }
  }

  void createAccount() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await FirebaseFirestore.instance
          .collection('citizen_user')
          .where('email', isEqualTo: email.text)
          .get();

      if (res.docs.length == 0) {
        Uint8List uint8list =
            Uint8List.fromList(File(photo!.path).readAsBytesSync());
        final ref = await FirebaseStorage.instance
            .ref()
            .child("validID/${photo!.name}");
        uploadTask = ref.putData(uint8list);
        final snapshot = await uploadTask!.whenComplete(() {});
        String fileLink = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('citizen_user').add({
          "email": email.text,
          "password": password.text,
          "firstname": firstname.text,
          "lastname": lastname.text,
          "contactno": contactno.text,
          "validIDurl": fileLink
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Account Succesfully Created.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email already exist.'),
        ));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/images/citizen.jpg',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextBold(
                      text: 'Create account as Citizen',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidth(8), right: getHeight(5)),
                      child: SizedBox(
                        width: getWidth(100),
                        child: TextBold(
                          text: 'Credential Details',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    TextFieldWidget(
                        isObscure: true,
                        isPassword: true,
                        label: 'Confirm password',
                        controller: retypepassword),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidth(8), right: getHeight(8)),
                      child: SizedBox(
                        width: getWidth(100),
                        child: TextBold(
                          text: 'User Information',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(label: 'First Name', controller: firstname),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(label: 'Last Name', controller: lastname),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                        onChangeText: onchangedTextEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        label: 'Contact No.',
                        controller: contactno),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidth(8), right: getHeight(8)),
                      child: SizedBox(
                        width: getWidth(100),
                        child: TextBold(
                          text: 'Valid ID',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidth(11), right: getWidth(11)),
                      child: InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: getHeight(15),
                          width: getWidth(100),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: photo != null
                              ? Image(image: FileImage(File(photo!.path)))
                              : Icon(Icons.add_a_photo_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      label: 'Create Account',
                      onPressed: () {
                        if (email.text.isEmpty ||
                            password.text.isEmpty ||
                            firstname.text.isEmpty ||
                            lastname.text.isEmpty ||
                            contactno.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Missing inputs.'),
                          ));
                        } else if (EmailValidator.validate(email.text) ==
                            false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid Email address.'),
                          ));
                        } else if (password.text != retypepassword.text) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Password not match.'),
                          ));
                        } else if (contactno.text.length != 10) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid Contact No.'),
                          ));
                        } else if (photo == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Missing Valid ID.'),
                          ));
                        } else {
                          createAccount();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
