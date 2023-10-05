import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sunspark/screens/new_page.dart';
import 'package:sunspark/services/add_report.dart';
import 'package:sunspark/widgets/button_widget.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:sunspark/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:sunspark/widgets/toast_widget.dart';
import 'package:telephony/telephony.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'citizen_screen.dart';

class AddReportPage extends StatefulWidget {
  final bool? inUser;

  const AddReportPage({super.key, this.inUser = true});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  @override
  void initState() {
    super.initState();
    determinePosition();
    addMarker();
  }

  // TwilioFlutter twilioFlutter = TwilioFlutter(
  //     accountSid:
  //         'ACeef255629207be814a1d605dc5ec9f8a', // replace *** with Account SID
  //     authToken:
  //         'e7725ea4e6c953bfc0fcf432bfbb12e8', // replace xxx with Auth Token
  //     twilioNumber: '+12569603461' // replace .... with Twilio Number
  //     );

  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid:
          'AC416086298c7539950fa857cb837ff2f8', // replace *** with Account SID
      authToken:
          'adf0405055629f063d464a9def81d164', // replace xxx with Auth Token
      twilioNumber: '+19899127501' // replace .... with Twilio Number
      );

  final nameController = TextEditingController();

  final numberController = TextEditingController();

  final addressController = TextEditingController();

  final statementController = TextEditingController();
  final othersController = TextEditingController();

  final Telephony telephony = Telephony.instance;

  List<String> type1 = [
    'Theft',
    'Assault',
    'Burglary',
    'Fraud',
    'Kidnapping',
    'Rape',
    'Robbery',
    'Murder',
    'Road Accident',
    'Others'
  ];
  String selected = 'Theft';

  Set<Marker> markers = {};

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;

  var selectedDateTime = DateTime.now();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String selectedOption = '';

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  double lat = 0;
  double long = 0;

  bool hasLoaded = false;
  String others = '';

  addMarker() {
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;

        markers.add(
          Marker(
            draggable: true,
            onDrag: (value) {
              setState(() {
                lat = value.latitude;
                long = value.longitude;
              });
            },
            icon: BitmapDescriptor.defaultMarker,
            markerId: const MarkerId('my location'),
            position: LatLng(position.latitude, position.longitude),
          ),
        );
        hasLoaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  List evidences = [];

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Evidences/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Evidences/$fileName')
            .getDownloadURL()
            .whenComplete(() {
          Navigator.of(context).pop();
        });

        evidences.add(imageURL);
        showToast(
            '${evidences.length} images are uploaded. You can upload multiple images');

        setState(() {});
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formattedDateTime =
        DateFormat('yyyy-MM-dd hh:mm a').format(selectedDateTime);
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              _sendSMS("Hi this is a sample message from the app");
            },
            child: TextRegular(
                text: 'Report Incident', fontSize: 18, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: hasLoaded
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
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
                          isRequred: true,
                          width: 350,
                          label: 'Name',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          isRequred: true,
                          inputType: TextInputType.number,
                          hint: '(ex. 9639530422)',
                          width: 350,
                          label: 'Phone Number',
                          controller: numberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a contact number';
                            }
                            if (!RegExp(r'^[9]\d{9}$').hasMatch(value)) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextRegular(
                          text: 'Are you a resident of Nabua?',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Yes',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                            const Text('Yes'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'No',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          isRequred: true,
                          width: 350,
                          label: 'Address',
                          controller: addressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }

                            return null;
                          },
                        ),
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
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                            underline: const SizedBox(),
                            value: selected,
                            items: type1.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'QRegular',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selected = newValue.toString();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: selected == 'Others' ? 20 : 0,
                        ),
                        selected == 'Others'
                            ? TextFieldWidget(
                                isRequred: true,
                                width: 350,
                                height: 50,
                                label: 'Please specify',
                                controller: othersController)
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // _selectDateTime(context);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: formattedDateTime,
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
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                onCameraMove: (position) {
                                  setState(() {
                                    lat = position.target.latitude;
                                    long = position.target.longitude;
                                  });
                                },
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 14.4746,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                            isRequred: true,
                            width: 350,
                            height: 50,
                            label: 'Statement',
                            controller: statementController),
                        const SizedBox(
                          height: 20,
                        ),
                        TextBold(
                          text: 'Evidence (photo)',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        imageURL != ''
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(imageURL),
                                      fit: BoxFit.cover),
                                ),
                                height: 100,
                                width: double.infinity,
                              )
                            : Container(
                                color: Colors.black,
                                height: 100,
                                width: double.infinity,
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                uploadPicture('gallery');
                              },
                              icon: const Icon(
                                Icons.file_upload,
                                color: Colors.black,
                              ),
                              label: TextRegular(
                                  text: 'Browse Gallery',
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                uploadPicture('camera');
                              },
                              icon: const Icon(
                                Icons.camera,
                                color: Colors.black,
                              ),
                              label: TextRegular(
                                  text: 'Camera',
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: check1,
                              onChanged: (value) {
                                setState(() {
                                  check1 = !check1;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 250,
                              child: Text(
                                'I certify that the information I provided in this form is accurate and true.',
                                style: TextStyle(fontFamily: 'QRegular'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: check2,
                              onChanged: (value) {
                                setState(() {
                                  check2 = !check2;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 250,
                              child: Text(
                                'I understand that any false statements I provided can be used against me.',
                                style: TextStyle(fontFamily: 'QRegular'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: check3,
                              onChanged: (value) {
                                setState(() {
                                  check3 = !check3;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 250,
                              child: Text(
                                'I understand that this document will be considered strictly condifential.',
                                style: TextStyle(fontFamily: 'QRegular'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: check4,
                              onChanged: (value) {
                                setState(() {
                                  check4 = !check4;
                                });
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CitizenScreen(
                                          inUser: true,
                                        )));
                              },
                              child: TextBold(
                                text: 'I agree with terms and conditions',
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        check1 == false ||
                                check2 == false ||
                                check3 == false ||
                                check4 == false
                            ? const SizedBox()
                            : Center(
                                child: ButtonWidget(
                                    label: 'Submit Reports',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        addReport(
                                            nameController.text,
                                            numberController.text,
                                            addressController.text,
                                            selected == 'Others'
                                                ? othersController.text
                                                : selected,
                                            selectedDateTime,
                                            lat,
                                            long,
                                            statementController.text,
                                            evidences,
                                            selectedOption);
                                        _sendSMS(
                                            'Incident: $selected\nReported by: ${nameController.text}\nReporter Contact Number: ${numberController.text}\nDate and Time: $selectedDateTime');
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: TextBold(
                                                  text: 'Alert',
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              content: TextRegular(
                                                  text:
                                                      'Your report was succesfully submitted!',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const NewPage()));
                                                  },
                                                  child: TextRegular(
                                                      text: 'Close',
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    })),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _sendSMS(String message) async {
    // await telephony.sendSms(to: '+639615381873', message: message);
    // twilioFlutter.sendSMS(toNumber: '+639199032452', messageBody: message);
    twilioFlutter.sendSMS(toNumber: '+639464720678', messageBody: message);

    //   accountSid:
    //     'ACa8246a5db6c24b81985b07ecec2b2589', // replace *** with Account SID
    // authToken:
    //     '47bd536791bcc6a57978aad7e2afda2d',
    // var credentials =
    //     'ACa8246a5db6c24b81985b07ecec2b2589:47bd536791bcc6a57978aad7e2afda2d';
    // var bytes = utf8.encode(credentials);
    // var base64Str = base64.encode(bytes);
    // var url = Uri.parse(
    //     'https://api.twilio.com/2010-04-01/Accounts/47bd536791bcc6a57978aad7e2afda2d/Messages.json');

    // var response = await http.post(url,
    //     headers: {'Authorization': 'Basic ${base64Str}'},
    //     body: {'From': '+19899127501', 'To': '+639464720678', 'Body': message});
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    setState(() {
      selectedDateTime = DateTime(
        pickedDateTime!.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedTime!.hour,
        pickedTime.minute,
      );
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
