import 'package:flutter/material.dart';

import '../widgets/text_widget.dart';

class CitizenScreen extends StatefulWidget {
  final bool? inUser;

  const CitizenScreen({super.key, this.inUser = true});

  @override
  State<CitizenScreen> createState() => _CitizenScreenState();
}

class _CitizenScreenState extends State<CitizenScreen> {
  bool check1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextRegular(
          text: 'Legal and Policies',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextBold(
                  text: 'Legal and Policies',
                  fontSize: 24,
                  color: Colors.black),
              const SizedBox(
                height: 10,
              ),
              TextRegular(
                  text:
                      'Child Abuse Prevention and Treatment Act (CAPTA): CAPTA is a federal law in the United States that mandates the reporting of child abuse and neglect by certain professionals and agencies.\nCrime Victims Rights Act (CVRA): CVRA is a federal law in the United States that outlines the rights of crime victims, including the right to be informed and consulted about the progress of their case.\nWhistleblower Protection Act: This federal law in the United States protects federal employees who report misconduct or illegal activities within government agencies from retaliation.\nGood Samaritan Laws: These laws exist in various states and countries and offer legal protection to individuals who provide assistance to those in need during emergencies or accidents.\nHealth Insurance Portability and Accountability Act (HIPAA): HIPAA is a federal law in the United States that governs the confidentiality and privacy of medical information, including incidents involving healthcare.\nDomestic Violence Reporting Laws: Many jurisdictions have specific laws requiring the reporting of domestic violence incidents, particularly by healthcare providers and law enforcement.\nElder Abuse Reporting Laws: Similar to child abuse laws, some places have specific laws that mandate the reporting of elder abuse, especially by healthcare and social service professionals.\nFalse Reporting Laws: Various jurisdictions have laws that penalize individuals for making false reports of incidents or crimes, as false reporting can divert resources and cause harm.\nFreedom of Information Act (FOIA): FOIA is a federal law in the United States that allows individuals to request access to government records, including incident and crime reports, with certain exceptions.\nData Protection Laws (e.g., GDPR): In many countries, data protection laws regulate the collection, storage, and sharing of personal data when reporting incidents or crimes, ensuring individuals privacy rights are respected.',
                  fontSize: 14,
                  color: Colors.grey),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
