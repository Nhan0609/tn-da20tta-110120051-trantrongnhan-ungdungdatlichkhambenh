import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/service/auth.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final user = FirebaseAuthService().currentUser;
  late PageController _pageController;
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  DateTime parseTimeSlot(String timeSlot) {
    String startTime = timeSlot.split('-')[0].trim();
    List<String> parts = startTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(0, 1, 1, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý lịch khám'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user!.uid)
            .where('status',
                whereIn: !isDeleted ? ['success', 'inprogress'] : ['cancel'])
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final newData = snapshot.data!.docs;
          newData.sort((a, b) {
            DateTime timeA = parseTimeSlot(a['time_slot']);
            DateTime timeB = parseTimeSlot(b['time_slot']);
            return timeA.compareTo(timeB);
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'Sắp đến hạn',
                        titleColor: !isDeleted ? Colors.white : Colors.black,
                        color: !isDeleted ? Colors.blue : Colors.white,
                        onPressed: () {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          setState(() {
                            isDeleted = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        title: 'Đã kết thúc',
                        titleColor: !isDeleted ? Colors.black : Colors.white,
                        color: !isDeleted ? Colors.white : Colors.blue,
                        onPressed: () {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          setState(() {
                            isDeleted = true;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable swipe to navigate
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final document = newData[index];
                            final hospitalId = document['hospitalId'];
                            final medicalId = document['medicalId'];
                            final timeSlot = document['time_slot'];
                            final status = document['status'];
                            final appointmentId = document.id;
                            return ExpansionTile(
                              title: _buildHeader(
                                document['date'],
                                status,
                                timeSlot,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _appointmentItem(
                                    context,
                                    medicalId,
                                    hospitalId,
                                    timeSlot,
                                    status,
                                    appointmentId,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newData.length,
                          itemBuilder: (context, index) {
                            final document = newData[index];
                            final hospitalId = document['hospitalId'];
                            final medicalId = document['medicalId'];
                            final timeSlot = document['time_slot'];
                            final status = document['status'];
                            final appointmentId = document.id;
                            return ExpansionTile(
                              title: _buildHeader(
                                  document['date'], isDeleted, timeSlot),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _appointmentItem(
                                    context,
                                    medicalId,
                                    hospitalId,
                                    timeSlot,
                                    status,
                                    appointmentId,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _appointmentItem(
    BuildContext context,
    String medicalId,
    String hospitalId,
    timeSlot,
    String status,
    appointmentId,
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
                  status != 'cancel'
                      ? _buildFooter(context, appointmentId)
                      : const SizedBox(),
                ],
              ),
            );
        }
      },
    );
  }

  renderStatus(status) {
    switch (status) {
      case 'success':
        return 'Đã đăng ký';
      case 'cancel':
        return 'Đã hủy';
      case 'inprogress':
        return 'Đang chờ xác nhận';
      default:
    }
  }

  renderStatusColor(status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'cancel':
        return Colors.redAccent;
      case 'inprogress':
        return Colors.blueAccent;
      default:
    }
  }

  Widget _buildHeader(date, status, timeSlot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          timeSlot,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        Row(
          children: [
            const Text(
              'Khám mới',
              style: TextStyle(fontSize: 16),
            ),
            
            const Spacer(),
            Chip(
              label: Text(
                renderStatus(status),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: renderStatusColor(status),
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
                      'Liên hệ quầy tiếp nhận',
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

  Widget _buildFooter(BuildContext context, id) {
    return Center(
      child: SizedBox(
        width: 160,
        child: ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('appointments')
                .doc(id)
                .update(
              {'status': 'cancel'},
            );
          },
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
