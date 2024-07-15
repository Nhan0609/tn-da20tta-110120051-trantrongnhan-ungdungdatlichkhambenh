import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/presentation/register_calender/widgets/calender.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:table_calendar/table_calendar.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  int selectedDateIndex = 0;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final user = FirebaseAuthService().currentUser;
  bool isReported = false;
  TextEditingController searchController = TextEditingController();
  String searchValue = '';
  int numberData = 0;

  final List<Map<String, dynamic>> hospitals = [
    {'title': 'Phòng Khám Da Liễu', 'id': 1},
    {'title': 'Phòng Chẩn đoán hình ảnh - TDCN', 'id': 2},
    {'title': 'Phòng khám mắt', 'id': 4},
    {'title': 'Phòng khám Tai - Mũi - Họng', 'id': 5},
    {'title': 'Phòng khám Phụ sản', 'id': 6},
    {'title': 'Phòng xét nghiệm', 'id': 3},
    {'title': 'Khám tổng quát', 'id': 7},
    {'title': 'Răng', 'id': 8},
  ];

  getCollectionLength(selectedStatus, selectedDay) async {
    print(selectedStatus);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: selectedStatus!['key'])
        .where(
          'date',
          isEqualTo: DateFormat('yyyy-MM-dd').format(
            selectedDay!,
          ),
        )
        .get();
    print(querySnapshot.docs.length);
    setState(() {
      numberData = querySnapshot.docs.length;
    });
  }

  final statusData = [
    {'title': 'Đã đăng ký', 'key': 'success'},
    {'title': 'Đã hủy', 'key': 'cancel'},
    {'title': 'Chờ xác nhận', 'key': 'inprogress'},
  ];

  Map<String, dynamic>? selectedHospital;
  Map<String, dynamic>? selectedStatus;

  DateTime parseTimeSlot(String timeSlot) {
    String startTime = timeSlot.split('-')[0].trim();
    List<String> parts = startTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(0, 1, 1, hour, minute);
  }

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    selectedHospital = hospitals[0];
    selectedStatus = statusData[0];
    getCollectionLength(selectedStatus, _selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thu ngân'),
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
                _focusedDay = focusedDay;
              });
              getCollectionLength(selectedStatus, selectedDay);
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
          Container(
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onPressed: () {
                    setState(() {
                      isReported = false;
                    });
                  },
                  title: 'TRA CỨU LỊCH',
                  color: !isReported ? Colors.white : Colors.blueAccent,
                ),
                CustomButton(
                  onPressed: () {
                    setState(() {
                      isReported = true;
                    });
                  },
                  title: 'THỐNG KÊ CUỘC HẸN',
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: DropdownButton<Map<String, dynamic>>(
                hint: const Text('Select a hospital'),
                value: selectedHospital,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedHospital = newValue;
                  });
                },
                items: hospitals.map((Map<String, dynamic> hospital) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: hospital,
                    child: Text(hospital['title']),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 20),
            Text(
              numberData.toString(),
              style: TextStyle(color: Colors.redAccent),
            )
          ]),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Mã bệnh nhân',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isReported)
            Center(
              child: DropdownButton<Map<String, dynamic>>(
                hint: const Text('Select a status'),
                value: selectedStatus,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                  getCollectionLength(selectedStatus, _selectedDay);
                },
                items: statusData.map((Map<String, dynamic> status) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: status,
                    child: Text(status['title']),
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getAppointmentStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No appointments found.'));
                }
                return Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return AppointmentCard(
                        medicalId: document['medicalId'],
                        time: document['date'],
                        slot: document['time_slot'],
                        status: document['status'],
                        paymentId: document['paymentId'],
                        id: document.id,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getAppointmentStream() {
    final baseQuery = FirebaseFirestore.instance
        .collection('appointments')
        .where(
          'hospitalId',
          isEqualTo: selectedHospital?['id'].toString(),
        )
        .where(
          'date',
          isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay!),
        );

    if (isReported) {
      return baseQuery
          .where('status', isEqualTo: selectedStatus!['key'])
          .snapshots();
    } else {
      if (searchValue.isNotEmpty) {
        return baseQuery
            .where('medicalId', isGreaterThanOrEqualTo: searchValue)
            .where('medicalId', isLessThan: '${searchValue}z')
            .limit(10) // Limit to reduce complexity
            .snapshots();
      } else {
        return baseQuery.snapshots();
      }
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final String medicalId;
  final String time;
  final String status;
  final String slot;
  final String paymentId;
  final String id;

  const AppointmentCard({
    super.key,
    required this.medicalId,
    required this.time,
    required this.status,
    required this.slot,
    required this.paymentId,
    required this.id,
  });

  String renderStatus(String status) {
    switch (status) {
      case 'success':
        return 'Đã đăng ký';
      case 'cancel':
        return 'Đã hủy';
      case 'inprogress':
        return 'Đang chờ xác nhận';
      default:
        return '';
    }
  }

  Color renderStatusColor(String status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'cancel':
        return Colors.redAccent;
      case 'inprogress':
        return Colors.blueAccent;
      default:
        return Colors.black;
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
                    color: renderStatusColor(status),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                paymentId.isNotEmpty
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
                Row(
                  children: [
                    CustomButton(
                      width: 130,
                      title: 'Xác nhận',
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(id)
                            .update({'status': 'success'});
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      width: 130,
                      title: 'Hủy',
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(id)
                            .update({'status': 'cancel'});
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
