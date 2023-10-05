import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunspark/screens/auth/landing_screen.dart';
import 'package:sunspark/screens/mewhome_screen.dart';
import 'package:sunspark/screens/pages/policy_page.dart';
import 'package:sunspark/screens/pages/profile_page.dart';
import 'package:sunspark/screens/pages/reports_page.dart';
import 'package:sunspark/widgets/text_widget.dart';

class DrawerWidget extends StatefulWidget {
  final bool? inUser;

  const DrawerWidget({super.key, this.inUser = true});

  @override
  State<DrawerWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<DrawerWidget> {
  // final Stream<DocumentSnapshot> userData =
  //     FirebaseFirestore.instance.collection('Users').doc(userId).snapshots();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = widget.inUser!
        ? FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('Officers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots();
    return StreamBuilder<DocumentSnapshot>(
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
          return SizedBox(
            width: 220,
            child: Drawer(
              child: ListView(
                padding: const EdgeInsets.only(top: 0),
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    accountEmail: TextRegular(
                        text: data['address'],
                        fontSize: 12,
                        color: Colors.white),
                    accountName: TextBold(
                      text: data['name'],
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    currentAccountPicture: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        minRadius: 50,
                        maxRadius: 50,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: TextBold(
                      text: 'Home',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NewHomeScreen(
                                inUser: widget.inUser,
                              )));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: TextBold(
                      text: 'Reports',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ReportsPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: TextBold(
                      text: 'Profile',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                inUser: widget.inUser,
                              )));
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.help),
                  //   title: TextBold(
                  //     text: 'Help',
                  //     fontSize: 12,
                  //     color: Colors.black,
                  //   ),
                  //   onTap: () {
                  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //         builder: (context) => const HomeScreen()));
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.policy),
                    title: TextBold(
                      text: 'Legal and Policies',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PolicyPage(
                                inUser: widget.inUser,
                              )));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: TextBold(
                      text: 'Logout',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  'Logout Confirmation',
                                  style: TextStyle(
                                      fontFamily: 'QBold',
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  'Are you sure you want to Logout?',
                                  style: TextStyle(fontFamily: 'QRegular'),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LandingScreen()));
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
