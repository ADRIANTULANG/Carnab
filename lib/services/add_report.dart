import 'package:cloud_firestore/cloud_firestore.dart';

Future addReport(name, contactNumber, address, type, dateAndTime, lat, long,
    statement, List evidencePhoto, nabuaResident) async {
  final docUser = FirebaseFirestore.instance.collection('Reports').doc();

  final json = {
    "name": name,
    "contactNumber": contactNumber,
    "address": address,
    "type": type,
    "dateAndTime": dateAndTime,
    "lat": lat,
    "long": long,
    "statement": statement,
    "evidencePhoto": evidencePhoto,
    "nabuaResident": nabuaResident,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'year': DateTime.now().year,
    'month': DateTime.now().month,
    'day': DateTime.now().day,
    'status': 'Processing'
  };

  await docUser.set(json);
}
