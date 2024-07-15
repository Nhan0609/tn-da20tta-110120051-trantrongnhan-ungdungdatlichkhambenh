import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/presentation/register_calender/widgets/calender.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int selectedDateIndex = 0;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final user = FirebaseAuthService().currentUser;
  late String? name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  void getName(hospitalId) async {
    final data = await FirebaseFirestore.instance
        .collection('hospital')
        .doc(hospitalId)
        .get();
    setState(() {
      name = data['title'];
    });
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
        title: Text(name ?? ''),
      ),
      body: Column(
        children: [
          // Calendar Header
          CustomCalender(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          // Tab Bar
          // Container(
          //   color: Colors.blueAccent,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       CustomButton(
          //         onPressed: () {},
          //         title: 'TRA CỨU LỊCH',
          //       ),
          //       CustomButton(
          //         onPressed: () {},
          //         title: 'THỐNG KÊ BỆNH ÁN',
          //       ),
          //     ],
          //   ),
          // ),
          // Appointment List
          // Expanded(
          //   child: ListView(
          //     children: [

          //   ],
          // ),
          // ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String hospitalId = userData['hospitalId'];
                    if (name == '') {
                      getName(hospitalId);
                    }
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('appointments')
                          .where('hospitalId', isEqualTo: hospitalId)
                          .where('status', isEqualTo: 'success')
                          .where('date',
                              isEqualTo: DateFormat('yyyy-MM-dd')
                                  .format(_selectedDay!))
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            List<Map<String, dynamic>> tempList =
                                snapshot.data!.docs.map((doc) {
                              var data = doc.data() as Map<String, dynamic>;
                              data['id'] =
                                  doc.id; // Thêm Document ID vào dữ liệu
                              return data;
                            }).toList();

                            tempList.sort((a, b) {
                              DateTime timeA = parseTimeSlot(a['time_slot']);
                              DateTime timeB = parseTimeSlot(b['time_slot']);
                              return timeA.compareTo(timeB);
                            });

                            return Container(
                              color: Colors.grey[200],
                              child: ListView.builder(
                                itemCount: tempList
                                    .length, // Total number of items in the list.
                                itemBuilder: (context, index) {
                                  final document = tempList[index];
                                  final medicalId = document['medicalId'];
                                  final timeSlot = document['time_slot'];
                                  final date = document['date'];
                                  final status = document['status'];
                                  final paymentId = document['paymentId'] ?? '';

                                  return AppointmentCard(
                                    medicalId: medicalId,
                                    time: '${date} ',
                                    slot: '${timeSlot}',
                                    status: status,
                                    paymentId: paymentId,
                                  );
                                },
                              ),
                            );
                        }
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String medicalId;
  final String time;
  final String status;
  final String slot;
  final String paymentId;

  const AppointmentCard({
    super.key,
    required this.medicalId,
    required this.time,
    required this.status,
    required this.slot,
    required this.paymentId,
  });

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

  @override
  Widget build(BuildContext context) {
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
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.account_circle, size: 50),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userData['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      renderStatus(status),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: renderStatusColor(status)),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Mã bệnh nhân: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(medicalId),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Ngày đăng ký: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(time),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Giờ đăng ký: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(slot),
                      ],
                    ),
                    const SizedBox(height: 5),
                    userData['insuranceCard'] != ''
                        ? Row(
                            children: [
                              const Text(
                                'Bảo hiểm y tế: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Text(userData['insuranceCard']),
                            ],
                          )
                        : const Row(
                            children: [
                              Text(
                                'Bảo hiểm y tế: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Text(
                                'Không có bảo hiểm',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                    const SizedBox(height: 5),
                    paymentId != ''
                        ? const Row(
                            children: [
                              Text(
                                'Đã thanh toán',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
