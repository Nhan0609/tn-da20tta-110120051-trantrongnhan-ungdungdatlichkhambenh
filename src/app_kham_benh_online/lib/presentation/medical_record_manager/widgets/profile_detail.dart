import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/service/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profileId});
  final String profileId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuthService().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Hồ sơ người thân',
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medical')
            .doc(widget?.profileId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              final userData = snapshot.data!.data();
              final nameController = userData!['name'];
              final phoneController = userData['phone'];
              final dobController = userData['dob'];
              final identificationCardController = userData['identificationCard'];
              final genderController = userData['gender'];
              final insuranceCardController = userData['insuranceCard'];
              final streetAddressController = userData['streetAddress'];
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildTextRow('Mã bệnh nhân', widget.profileId),
                  const SizedBox(height: 10),
                  buildTextRow('Mã bảo hiểm y tế', insuranceCardController),
                  const SizedBox(height: 10),
                  buildTextRow('CCCD/CMND', identificationCardController),
                  const SizedBox(height: 20),
                  buildTextRow('Họ và tên', nameController),
                  const SizedBox(height: 10),
                  buildTextRow('Số điện thoại', phoneController),
                  const SizedBox(height: 10),
                  buildTextRow('Ngày sinh', dobController),
                  const SizedBox(height: 10),
                  buildTextRow('Giới tính', genderController),
                  const SizedBox(height: 10),
                  buildTextRow('Địa chỉ', streetAddressController),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {
                      context.push(RouterPath.updateProfile.replaceAll(
                        ':id',
                        widget.profileId,
                      ));
                    },
                    title: 'Cập nhật',
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Widget buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            value != '' ? value : 'Chưa cập nhật',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: value == '' ? Colors.redAccent : null,
            ),
          ),
        ],
      ),
    );
  }
}
