import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/screens/pages/details_page.dart';
import 'package:sunspark/widgets/text_widget.dart';

class NotifScreen extends StatefulWidget {
  final bool? inUser;

  const NotifScreen({super.key, this.inUser = true});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  String nameSearched = '';
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextRegular(
          text: 'Notifications',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Reports')
                    .where('status', isEqualTo: 'Processing')
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                // if (widget.inUser! == false) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                          reportId: data.docs[index].id,
                                        )));
                                // }
                              },
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.notifications,
                                    color: Colors.red,
                                  ),
                                  title: TextRegular(
                                      text:
                                          '${data.docs[index]['name']} added a new report',
                                      fontSize: 14,
                                      color: Colors.black),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextRegular(
                                          text: DateFormat.yMMMd()
                                              .add_jm()
                                              .format(data.docs[index]
                                                      ['dateAndTime']
                                                  .toDate()),
                                          fontSize: 10,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextBold(
                                          text: data.docs[index]['status'] ==
                                                  'Processing'
                                              ? 'New'
                                              : data.docs[index]['status'],
                                          fontSize: 10,
                                          color: data.docs[index]['status'] ==
                                                  'Processing'
                                              ? Colors.blue
                                              : data.docs[index]['status'] ==
                                                      'Resolved'
                                                  ? Colors.green
                                                  : Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
