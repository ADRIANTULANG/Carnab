import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';

class DetailsPage extends StatefulWidget {
  final String reportId;
  const DetailsPage({super.key, required this.reportId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final nameController = TextEditingController();

  final numberController = TextEditingController();

  final addressController = TextEditingController();

  final statementController = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String selectedOption = '';

  Set<Marker> markers = {};

  bool isReportTaken = false;

  String officerName = '';
  String officerID = '';

  getPoliceInfo() async {
    try {
      String userid = await FirebaseAuth.instance.currentUser!.uid;
      var result = await FirebaseFirestore.instance
          .collection('Officers')
          .doc(userid)
          .get();
      var officerInfo = result.data();
      if (officerInfo != null) {
        officerName = officerInfo['name'];
        officerID = officerInfo['id'];
      }
    } catch (e) {
      print(e);
    }
  }

  addMarker(double lat, double long) {
    markers.add(
      Marker(
        draggable: false,
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('my location'),
        position: LatLng(lat, long),
      ),
    );
  }

  checkifReportTaken() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('Reports')
          .doc(widget.reportId)
          .get();

      var reportData = await result.data();
      if (reportData != null) {
        if (reportData.containsKey('police_taked_action')) {
          setState(() {
            isReportTaken = true;
          });
        } else {
          setState(() {
            isReportTaken = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  takeAction() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('Reports')
          .doc(widget.reportId)
          .get();

      var reportData = await result.data();
      if (reportData != null) {
        if (reportData.containsKey('police_taked_action')) {
          Fluttertoast.showToast(
              msg: "The report has already been addressed.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Report taken.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          String userid = await FirebaseAuth.instance.currentUser!.uid;
          var officerDocumentRef = await FirebaseFirestore.instance
              .collection('Officers')
              .doc(userid);
          await FirebaseFirestore.instance
              .collection('Reports')
              .doc(widget.reportId)
              .update({
            "police_taked_action": officerDocumentRef,
            "police_name": officerName,
            "date_taken": Timestamp.now()
          });
        }
      }
      checkifReportTaken();
    } catch (e) {
      print(e);
    }
  }

  // populateValidID() async {
  //   try {
  //     var result = await FirebaseFirestore.instance.collection('Reports').get();
  //     var reports = result.docs;
  //     WriteBatch batch = FirebaseFirestore.instance.batch();
  //     for (var i = 0; i < reports.length; i++) {
  //       var documentRef = await FirebaseFirestore.instance
  //           .collection('Reports')
  //           .doc(reports[i].id);
  //       batch.update(documentRef, {"date_taken": Timestamp.now()});
  //     }
  //     await batch.commit();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  @override
  void initState() {
    getPoliceInfo();
    checkifReportTaken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Reports')
        .doc(widget.reportId)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: TextRegular(
              text: 'Report Details', fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
                stream: userData,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Loading'));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  dynamic data = snapshot.data;

                  if (markers.isEmpty) {
                    addMarker(data['lat'], data['long']);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(
                        text: 'Witness Information',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          enabled: false,
                          hint: data['name'],
                          width: 350,
                          label: 'Name',
                          controller: nameController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          enabled: false,
                          hint: data['contactNumber'],
                          width: 350,
                          label: 'Phone Number',
                          controller: numberController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextBold(
                        text: 'Resident of Nabua?',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            data['nabuaResident'] == 'Yes'
                                ? Icons.radio_button_checked_sharp
                                : Icons.radio_button_off,
                          ),
                          const Text('Yes'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            data['nabuaResident'] != 'Yes'
                                ? Icons.radio_button_checked_sharp
                                : Icons.radio_button_off,
                          ),
                          const Text('No'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          enabled: false,
                          hint: data['address'],
                          width: 350,
                          label: 'Address',
                          controller: addressController),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBold(
                        text: 'Incident Information',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: TextRegular(
                            text: 'Incident Type:',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                data['type'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'QRegular',
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        child: IgnorePointer(
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                              text: '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Date and Time',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBold(
                              text: 'Incident Location',
                              fontSize: 14,
                              color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.black,
                            height: 200,
                            width: double.infinity,
                            child: GoogleMap(
                              markers: markers,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(data['lat'], data['long']),
                                zoom: 14.4746,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                if (_controller.isCompleted) {
                                } else {
                                  _controller.complete(controller);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                          enabled: false,
                          hint: data['statement'],
                          width: 350,
                          height: 50,
                          label: 'Statement',
                          controller: statementController),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBold(
                        text: 'Evidences (photo)',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      for (int i = 0; i < data['evidencePhoto'].length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data['evidencePhoto'][i]),
                                  fit: BoxFit.cover),
                            ),
                            height: 100,
                            width: double.infinity,
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextBold(
                        text: 'Valid ID (photo)',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(data['validID']),
                                fit: BoxFit.cover),
                          ),
                          height: 230,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextBold(
                        text: 'Report Progress',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          if (data['status'] != 'Resolved') {
                            await FirebaseFirestore.instance
                                .collection('Reports')
                                .doc(data.id)
                                .update({'status': 'Processing'});
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              data['status'] == 'Processing'
                                  ? Icons.radio_button_checked_sharp
                                  : Icons.radio_button_off,
                            ),
                            const Text('Processing'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          if (data['status'] != 'Resolved') {
                            await FirebaseFirestore.instance
                                .collection('Reports')
                                .doc(data.id)
                                .update({'status': 'Resolved'});
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              data['status'] == 'Resolved'
                                  ? Icons.radio_button_checked_sharp
                                  : Icons.radio_button_off,
                            ),
                            const Text('Resolved'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          if (data['status'] != 'Resolved') {
                            await FirebaseFirestore.instance
                                .collection('Reports')
                                .doc(data.id)
                                .update({'status': 'Unresolved'});
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              data['status'] == 'Unresolved'
                                  ? Icons.radio_button_checked_sharp
                                  : Icons.radio_button_off,
                            ),
                            const Text('Unresolved'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      isReportTaken == true
                          ? Container(
                              width: getWidth(100),
                              alignment: Alignment.center,
                              child: Text(
                                "Police action has been initiated in response to this report.",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ))
                          : Align(
                              alignment: Alignment.center,
                              child: ButtonWidget(
                                label: 'Take Action',
                                onPressed: () {
                                  takeAction();
                                },
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}
