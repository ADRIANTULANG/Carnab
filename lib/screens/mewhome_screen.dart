import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/screens/pages/details_page.dart';
import 'package:sunspark/screens/pages/notif_page.dart';
import 'package:sunspark/widgets/drawer_widget.dart';

import '../widgets/text_widget.dart';
import 'home_screen.dart';

class NewHomeScreen extends StatefulWidget {
  final bool? inUser;

  const NewHomeScreen({
    super.key,
    this.inUser = true,
  });

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
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

  String filter = 'Types';

  List<String> filters = ['Types', 'Status', 'Date'];

  String status = 'New';

  List<String> statuses = [
    'New',
    'Resolved',
    'Unresolved',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerWidget(
          inUser: widget.inUser,
        ),
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextRegular(
                text: 'Filter by:',
                fontSize: 18,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<String>(
                  underline: const SizedBox(),
                  value: filter,
                  items: filters.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Center(
                        child: SizedBox(
                          width: 325,
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
                      filter = newValue.toString();
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              filter == 'Date'
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              dateFromPicker(context);
                            },
                            child: SizedBox(
                              width: 350,
                              height: 50,
                              child: TextFormField(
                                enabled: false,
                                style: const TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),

                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.blue,
                                  ),
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  hintText: dateController.text,
                                  border: InputBorder.none,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorStyle: const TextStyle(
                                      fontFamily: 'Bold', fontSize: 12),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                controller: dateController,
                                // Pass the validator to the TextFormField
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: filter == 'Date' ? 20 : 0),
              filter == 'Types'
                  ? Expanded(
                      child: GridView.builder(
                        itemCount: type1.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Reports')
                                  .where('type', isEqualTo: type1[index])
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

                                final newData = snapshot.requireData;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                  filter: type1[index],
                                                  inUser: widget.inUser,
                                                  inTypes: true,
                                                )));
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextBold(
                                          text: newData.docs.length.toString(),
                                          fontSize: 48,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextRegular(
                                          text: type1[index],
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    )
                  : filter == 'Status'
                      ? Expanded(
                          child: GridView.builder(
                            itemCount: statuses.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Reports')
                                      .where('status',
                                          isEqualTo: statuses[index])
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

                                    final newData = snapshot.requireData;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                      filter: statuses[index],
                                                      inUser: widget.inUser,
                                                      inTypes: false,
                                                    )));
                                      },
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextBold(
                                              text: newData.docs.length
                                                  .toString(),
                                              fontSize: 32,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextRegular(
                                              text: statuses[index],
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        )
                      : Column(
                          children: [
                            const TabBar(
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 350,
                              width: 500,
                              child: TabBarView(children: [
                                stream('Processing'),
                                stream('Unresolved'),
                                stream('Resolved'),
                              ]),
                            ),
                          ],
                        )
            ],
          ),
        ),
      ),
    );
  }

  Widget stream(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Reports')
          .where('day', isEqualTo: dates.day)
          .where('month', isEqualTo: dates.month)
          .where('year', isEqualTo: dates.year)
          .where('status', isEqualTo: filter)
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

  final dateController = TextEditingController();

  DateTime dates = DateTime.now();

  void dateFromPicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        dates = pickedDate;
        dateController.text = formattedDate;
      });
    } else {
      return null;
    }
  }
}
