import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/clinic_card_item.dart';

class ListMedicalClinic extends StatefulWidget {
  const ListMedicalClinic({super.key});

  @override
  State<ListMedicalClinic> createState() => _ListMedicalClinicState();
}

class _ListMedicalClinicState extends State<ListMedicalClinic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Danh sách bênh viện'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('hospital').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  itemCount: snapshot
                      .data!.docs.length, // Total number of items in the list.
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot
                        .data!.docs[index]; // Get document at the specific index.
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClinicInfoCard(
                        image: document['image'],
                        title: document['title'],
                        description: document['description'],
                        address: document['address'],
                        id: document.id,
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
