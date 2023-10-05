import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addAccount(name, email, age, gender, address) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'age': age,
    'gender': gender,
    'address': address,
    'id': docUser.id,
    'profilePicture': 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
  };

  await docUser.set(json);
}
