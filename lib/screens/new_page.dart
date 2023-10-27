import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunspark/screens/auth/landing_screen.dart';

import '../widgets/text_widget.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    getHeight(percent) {
      var toDecimal = percent / 100;
      return MediaQuery.of(context).size.height * toDecimal;
    }

    // getWidth(percent) {
    //   var toDecimal = percent / 100;
    //   return MediaQuery.of(context).size.width * toDecimal;
    // }

    getBack() async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LandingScreen()));
      return false;
    }

    return WillPopScope(
      onWillPop: () => getBack(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: TextRegular(
              text: 'REPORTS',
              fontSize: 18,
              color: Colors.white,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LandingScreen()));
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Column(
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
              SizedBox(
                height: getHeight(1),
              ),
              Expanded(
                child: SizedBox(
                  child: TabBarView(children: [
                    stream('Processing'),
                    stream('Unresolved'),
                    stream('Resolved'),
                  ]),
                ),
              ),
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
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final document = data.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () {},
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
