import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/screens/pages/details_page.dart';
import 'package:sunspark/widgets/text_widget.dart';

import '../../widgets/drawer_widget.dart';

class ReportsPage extends StatefulWidget {
  final bool? inUser;

  const ReportsPage({super.key, this.inUser = true});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String nameSearched = '';
  final searchController = TextEditingController();

  List<String> type1 = [
    'Processing',
    'Resolved',
    'Unresolved',
  ];
  String selected = 'Processing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(
        inUser: false,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: TextRegular(
          text: 'Reports',
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
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextBold(
              text: 'REPORTS',
              fontSize: 18,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Reports')
                    .where('status', isEqualTo: selected)
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
                                if (widget.inUser! == false) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                            reportId: data.docs[index].id,
                                          )));
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: TextBold(
                                      text: data.docs[index]['type'],
                                      fontSize: 18,
                                      color: Colors.black),
                                  subtitle: TextRegular(
                                      text: data.docs[index]['statement'],
                                      fontSize: 12,
                                      color: Colors.grey),
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
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextBold(
                                          text: data.docs[index]['status'],
                                          fontSize: 12,
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
