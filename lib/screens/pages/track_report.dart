import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackReportView extends StatefulWidget {
  const TrackReportView({super.key, required this.documentID});
  final String documentID;

  @override
  State<TrackReportView> createState() =>
      _TrackReportViewState(documentID: documentID);
}

class _TrackReportViewState extends State<TrackReportView> {
  _TrackReportViewState({required this.documentID});
  String documentID;
  Map? reportData;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getReport() async {
    var res = await FirebaseFirestore.instance
        .collection('Reports')
        .doc(documentID)
        .get();

    var report = res.data();
    if (report != null) {
      report['dateAndTime'] = report['dateAndTime'].toDate().toString();
      report['dateTime'] = report['dateTime'].toDate().toString();
      if (report.containsKey('police_taked_action')) {
        report['date_taken'] = report['date_taken'].toDate().toString();
        var police_info = await report['police_taked_action'].get();
        report['police_taked_action'] = police_info.data();
      }
      reportData = report;

      setState(() {
        markers.add(
          Marker(
            draggable: false,
            icon: BitmapDescriptor.defaultMarker,
            markerId: const MarkerId('my location'),
            position: LatLng(report['lat'], report['long']),
          ),
        );
      });
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    getReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: reportData == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.only(
                      left: getWidth(5), right: getWidth(5), top: getHeight(2)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBold(
                            text: "Track Report",
                            fontSize: 25,
                            color: Colors.black),
                        SizedBox(
                          height: getHeight(1),
                        ),
                        Row(
                          children: [
                            TextRegular(
                                text: "Tracking code: ",
                                fontSize: 15,
                                color: Colors.black),
                            TextBold(
                                text: documentID,
                                fontSize: 15,
                                color: Colors.black),
                          ],
                        ),
                        Row(
                          children: [
                            TextRegular(
                                text: "Status: ",
                                fontSize: 15,
                                color: Colors.black),
                            TextBold(
                                text: reportData?['status'] == null
                                    ? ""
                                    : reportData!['status'],
                                fontSize: 15,
                                color: reportData == null
                                    ? Colors.black
                                    : reportData!['status'] == "Processing"
                                        ? Colors.orange
                                        : reportData!['status'] == "Unresolved"
                                            ? Colors.red
                                            : reportData!['status'] ==
                                                    "Resolved"
                                                ? Colors.green
                                                : Colors.black),
                          ],
                        ),
                        Row(
                          children: [
                            TextRegular(
                                text: "Date Reported: ",
                                fontSize: 15,
                                color: Colors.black),
                            TextRegular(
                                text: reportData?['dateAndTime'] == null
                                    ? ""
                                    : "${DateFormat.yMMMEd().format(DateTime.parse(reportData!['dateAndTime']))} ${DateFormat.jm().format(DateTime.parse(reportData!['dateAndTime']))}",
                                fontSize: 15,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: getHeight(3),
                        ),
                        TextBold(
                            text: "Witness Info",
                            fontSize: 15,
                            color: Colors.black),
                        SizedBox(
                          height: getHeight(2),
                        ),
                        TextRegular(
                            text: reportData?['name'] == null
                                ? ""
                                : reportData!['name'],
                            fontSize: 15,
                            color: Colors.black),
                        TextRegular(
                            text: reportData?['contactNumber'] == null
                                ? ""
                                : reportData!['contactNumber'],
                            fontSize: 15,
                            color: Colors.black),
                        SizedBox(
                          height: getHeight(2),
                        ),
                        Container(
                          height: getHeight(30),
                          width: getWidth(100),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(reportData!['validID']))),
                        ),
                        SizedBox(
                          height: getHeight(2),
                        ),
                        TextBold(
                            text: "Location Info",
                            fontSize: 15,
                            color: Colors.black),
                        SizedBox(
                          height: getHeight(2),
                        ),
                        TextRegular(
                            text: reportData?['address'] == null
                                ? ""
                                : reportData!['address'],
                            fontSize: 15,
                            color: Colors.black),
                        SizedBox(
                          height: getHeight(2),
                        ),
                        Container(
                          color: Colors.black,
                          height: 200,
                          width: double.infinity,
                          child: GoogleMap(
                            markers: markers,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  reportData!['lat'], reportData!['long']),
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
                        SizedBox(
                          height: getHeight(
                              reportData!['evidencePhoto'].length > 0 ? 2 : 0),
                        ),
                        reportData!['evidencePhoto'].length > 0
                            ? TextBold(
                                text: "Evidence (Photo)",
                                fontSize: 15,
                                color: Colors.black)
                            : SizedBox(),
                        SizedBox(
                          height: getHeight(
                              reportData!['evidencePhoto'].length > 0 ? 2 : 0),
                        ),
                        for (int i = 0;
                            i < reportData!['evidencePhoto'].length;
                            i++)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      reportData!['evidencePhoto'][i]),
                                  fit: BoxFit.cover),
                            ),
                            height: getHeight(15),
                            width: getWidth(100),
                          ),
                        SizedBox(
                          height: getHeight(
                              reportData?['police_name'] == null ? 0 : 2),
                        ),
                        reportData?['police_name'] == null
                            ? SizedBox()
                            : TextBold(
                                text: "Police info",
                                fontSize: 15,
                                color: Colors.black),
                        SizedBox(
                          height: getHeight(
                              reportData?['police_name'] == null ? 0 : 1),
                        ),
                        reportData?['police_name'] == null
                            ? SizedBox()
                            : TextRegular(
                                text: reportData!['police_name'],
                                fontSize: 15,
                                color: Colors.black),
                        reportData?['police_name'] == null
                            ? SizedBox()
                            : TextRegular(
                                text: reportData!['police_taked_action']
                                    ['contactnumber'],
                                fontSize: 15,
                                color: Colors.black),
                        reportData?['police_name'] == null
                            ? SizedBox()
                            : TextRegular(
                                text: reportData!['police_taked_action']
                                    ['address'],
                                fontSize: 15,
                                color: Colors.black),
                        SizedBox(
                          height: getHeight(
                              reportData?['police_name'] == null ? 0 : 2),
                        ),
                        reportData?['police_name'] == null
                            ? SizedBox()
                            : Container(
                                width: getWidth(100),
                                alignment: Alignment.center,
                                child: ButtonWidget(
                                  label: 'Call Police',
                                  onPressed: () {
                                    makePhoneCall(
                                        reportData!['police_taked_action']
                                            ['contactnumber']);
                                  },
                                ),
                              ),
                        SizedBox(
                          height: getHeight(
                              reportData?['police_name'] == null ? 0 : 2),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
