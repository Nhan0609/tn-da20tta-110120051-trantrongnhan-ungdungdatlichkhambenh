import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koruko_app/service/auth.dart';

class PagerView1 extends StatefulWidget {
  const PagerView1({super.key});

  @override
  State<PagerView1> createState() => _PagerView1State();
}

class _PagerView1State extends State<PagerView1> {
  final user = FirebaseAuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user!.uid)
          .where('isDeleted', isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No appointments found.'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                final hospitalId = document['hospitalId'];
                final medicalId = document['medicalId'];
                final timeSlot = document['time_slot'];
                return ExpansionTile(
                  title: _buildHeader(document['date']),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _appointmentItem(
                          context, medicalId, hospitalId, timeSlot),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _appointmentItem(
    BuildContext context,
    String medicalId,
    String hospitalId,
    timeSlot,
  ) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medical')
          .doc(medicalId.trim())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User data not found.'));
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppointmentDetails(hospitalId, timeSlot),
                  const SizedBox(height: 16),
                  _buildPatientInfoHospital(userData, hospitalId),
                  const SizedBox(height: 16),
                  _buildPatientInfo(userData, medicalId),
                  const SizedBox(height: 32),
                  _buildFooter(context),
                ],
              ),
            );
        }
      },
    );
  }

  Widget _buildHeader(date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'Khám mới',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Chip(
              label: const Text(
                'Đã đăng ký',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green[400],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails(hospitalId, timeSlot) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hospital')
          .doc(hospitalId.trim())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User data not found.'));
        }
        final hospital = snapshot.data!.data() as Map<String, dynamic>;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Thời gian dự kiến:', timeSlot),
                    _buildDetailRow(
                      'Khu vực thực hiện:',
                      'Cổng 2 - Khu C - Quầy 1',
                    ),
                    const SizedBox(height: 8),
                    // Image.asset('assets/map.png'), // Add a placeholder for the map image
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _buildPatientInfo(data, medicalId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin bệnh nhân',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Image.asset('assets/barcode.png'), // Add a placeholder for the barcode image
        _buildDetailRow('Mã bệnh nhân:', medicalId),
        _buildDetailRow('Bệnh nhân:', data['name']),
        _buildDetailRow('Giới tính:', data['gender']),
        _buildDetailRow('Năm sinh:', data['dob']),
        const SizedBox(height: 8),
        const Text(
          'Lưu ý:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          '- Khi khám bệnh vui lòng đến quầy CSKH và cho nhân viên xem phiếu khám này.',
          style: TextStyle(fontSize: 14),
        ),
        const Text(
          '- Vui lòng đến sớm 15 phút trước giờ khám.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  _buildPatientInfoHospital(data, hospitalId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hospital')
          .doc(hospitalId.trim())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User data not found.'));
        }
        final hospital = snapshot.data!.data() as Map<String, dynamic>;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi tiết lịch khám',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Image.asset('assets/barcode.png'), // Add a placeholder for the barcode image
                _buildDetailRow(
                  'Dịch vụ:',
                  data['insuranceCard'].isNotEmpty
                      ? 'Khám bệnh có bảo hiểm y tế'
                      : 'Khám bệnh không bảo hiểm y tế',
                ),
                _buildDetailRow('Chuyên khoa:', hospital['description']),
              ],
            );
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 160,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Hủy đăng ký',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
