import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/presentation/medical_record_manager/widgets/user_card.dart';
import 'package:koruko_app/service/auth.dart';

class MedicalListProfile extends StatefulWidget {
  const MedicalListProfile({super.key});

  @override
  State<MedicalListProfile> createState() => _MedicalListProfileState();
}

class _MedicalListProfileState extends State<MedicalListProfile> {
  final user = FirebaseAuthService().currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Danh sách đăng ký',
        actions: [
          CustomIconButton(
            icon: Icons.person_add_alt_1,
            onPressed: () => context.push(RouterPath.registerProfile),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medical')
            .where('userId', isEqualTo: user!.uid)
            .where('isDeleted', isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return Container(
                color: Colors.grey[200],
                child: ListView.builder(
                  itemCount: snapshot
                      .data!.docs.length, // Total number of items in the list.
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!
                        .docs[index]; // Get document at the specific index.
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserCard(
                        name: document['name'],
                        id: document['insuranceCard'],
                        dob: document['dob'],
                        onDelete: () => showDeleteDialog(context, document),
                        onUpdate: () {
                          context.push(RouterPath.profileDetail.replaceAll(
                            ':id',
                            document.id,
                          ));
                        },
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

  void showDeleteDialog(BuildContext context, document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn chắc chắn muốn xóa hồi sơ này?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Xác nhận"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('medical')
                    .doc(document.id)
                    .update({'isDeleted': true});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
