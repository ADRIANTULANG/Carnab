import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addReport(
    name,
    contactNumber,
    address,
    type,
    dateAndTime,
    lat,
    long,
    addressLat,
    addressLong,
    statement,
    List evidencePhoto,
    nabuaResident,
    validID) async {
  final docUser = FirebaseFirestore.instance.collection('Reports').doc();

  final json = {
    "name": name,
    "contactNumber": contactNumber,
    "address": address,
    "type": type,
    "dateAndTime": dateAndTime,
    "lat": lat,
    "long": long,
    "addressLat": addressLat,
    "addressLong": addressLong,
    "statement": statement,
    "evidencePhoto": evidencePhoto,
    "nabuaResident": nabuaResident,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'year': DateTime.now().year,
    'month': DateTime.now().month,
    'day': DateTime.now().day,
    'status': 'Processing',
    'validID': validID
  };

  await docUser.set(json);
  return docUser.id;
}
