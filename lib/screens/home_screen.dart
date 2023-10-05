import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/screens/add_report_page.dart';
import 'package:sunspark/screens/pages/details_page.dart';
import 'package:sunspark/screens/pages/notif_page.dart';
import 'package:sunspark/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class HomeScreen extends StatefulWidget {
  final bool? inUser;
  final bool? inTypes;
  final String? filter;

  const HomeScreen(
      {super.key, this.inUser = true, required this.inTypes, this.filter = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nameSearched = '';
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: widget.inUser!
            ? FloatingActionButton(
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddReportPage()));
                })
            : const SizedBox(),
        appBar: AppBar(
          centerTitle: true,
          title: TextRegular(
            text: 'HOME',
            fontSize: 18,
            color: Colors.white,
          ),
          actions: [
            !widget.inUser!
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NotifScreen()));
                    },
                    icon: Badge(
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      label: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Reports')
                              .where('status', isEqualTo: 'Processing')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return const Center(child: Text('Error'));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                            return TextRegular(
                                text: data.docs.length.toString(),
                                fontSize: 14,
                                color: Colors.white);
                          }),
                      child: const Icon(
                        Icons.notifications,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.inTypes!
                  ? const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontFamily: 'Bold',
                        color: Colors.black,
                      ),
                      tabs: [
                        Tab(
                          text: 'New',
                        ),
                        Tab(
                          text: 'Unresolved',
                        ),
                        Tab(
                          text: 'Resolved',
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 375,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        nameSearched = value;
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: 'QRegular'),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                    controller: searchController,
                  ),
                ),
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
              widget.inTypes!
                  ? Expanded(
                      child: TabBarView(children: [
                        stream('Processing'),
                        stream('Unresolved'),
                        stream('Resolved'),
                      ]),
                    )
                  : Expanded(child: stream(widget.filter!)),
            ],
          ),
        ),
      ),
    );
  }

  Widget stream(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.inTypes!
          ? FirebaseFirestore.instance
              .collection('Reports')
              .where('type',
                  isGreaterThanOrEqualTo:
                      toBeginningOfSentenceCase(nameSearched))
              .where('type',
                  isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
              .where('status', isEqualTo: filter)
              .where('type', isEqualTo: widget.filter)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Reports')
              .where('type',
                  isGreaterThanOrEqualTo:
                      toBeginningOfSentenceCase(nameSearched))
              .where('type',
                  isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
              .where('status', isEqualTo: widget.filter)
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              ),
            ),
          );
        }

        final data = snapshot.requireData;

        return SizedBox(
          height: 750,
          child: ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final document = data.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    if (widget.inUser! == false) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          reportId: document.id,
                        ),
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: document['status'] == 'Processing'
                          ? Colors.blue
                          : document['status'] == 'Resolved'
                              ? Colors.green
                              : Colors.red,
                    ),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        title: TextBold(
                          text: document['type'],
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        subtitle: TextRegular(
                          text: document['statement'],
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextRegular(
                              text: DateFormat.yMMMd()
                                  .add_jm()
                                  .format(document['dateAndTime'].toDate()),
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextBold(
                              text: document['status'] == 'Processing'
                                  ? 'New'
                                  : document['status'],
                              fontSize: 12,
                              color: document['status'] == 'Processing'
                                  ? Colors.blue
                                  : document['status'] == 'Resolved'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
