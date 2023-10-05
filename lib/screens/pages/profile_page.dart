import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunspark/widgets/text_widget.dart';

import '../../widgets/drawer_widget.dart';

class ProfilePage extends StatelessWidget {
  final bool? inUser;

  const ProfilePage({super.key, this.inUser = true});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = inUser!
        ? FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('Officers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots();
    return Scaffold(
      drawer: DrawerWidget(
        inUser: inUser,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: TextRegular(
          text: 'PROFILE',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/profile.png',
                    height: 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBold(
                      text: data['name'], fontSize: 18, color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  TextRegular(
                      text: 'Full Name', fontSize: 12, color: Colors.grey),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBold(
                      text: 'Police Officer 1',
                      fontSize: 18,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  TextRegular(
                      text: 'Position', fontSize: 12, color: Colors.grey),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBold(
                      text: data['age'], fontSize: 18, color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  TextRegular(text: 'Age', fontSize: 12, color: Colors.grey),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBold(
                      text: data['gender'], fontSize: 18, color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  TextRegular(text: 'Gender', fontSize: 12, color: Colors.grey),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBold(
                      text: data['address'], fontSize: 18, color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  TextRegular(
                      text: 'Address', fontSize: 12, color: Colors.grey),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
