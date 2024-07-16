import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/presentation/medical_record_manager/widgets/user_card.dart';
import 'package:koruko_app/presentation/register_calender/model/time.model.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:table_calendar/table_calendar.dart';

import 'widgets/calender.dart';

class RegisterCalender extends StatefulWidget {
  const RegisterCalender({super.key, required this.medicalId});

  final String medicalId;

  @override
  State<RegisterCalender> createState() => _RegisterCalenderState();
}

class _RegisterCalenderState extends State<RegisterCalender> {
  late PageController _pageController;

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  TimeSlot? selectedSlot;
  bool isNext = false;

  final user = FirebaseAuthService().currentUser;
  late bool isPayment = false;
  late String paymentId = '';

  late List<TimeSlot> _availableTimeSlotsMorning;
  late List<TimeSlot> _availableTimeSlotsAfternoon;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot? selectedUser;
  DocumentSnapshot? selectedMedical;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _availableTimeSlotsMorning = [];
    _availableTimeSlotsAfternoon = [];
    getSelectedMedical();
  }

  void getSelectedMedical() async {
    final data = await FirebaseFirestore.instance
        .collection('hospital')
        .doc(widget.medicalId)
        .get();
    setState(() {
      selectedMedical = data;
    });
  }

  void _fetchAvailableTimeSlots(DateTime selectedDay) async {
    if (isAfternoonSaturdayOrSunday(selectedDay)) {
      // Format the selected date to match the format stored in Firestore
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      // Assuming morningSlots and afternoonSlots are lists of TimeSlot objects
      final listMorning = List<TimeSlot>.from(morningSlots);
      // Fetch appointments from Firestore
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: formattedDate)
          .where('hospitalId', isEqualTo: widget.medicalId)
          .where('status', isEqualTo: 'success')
          .where('status', isEqualTo: 'inprogress')
          .get()
          .then((snapshot) {
        List<String> bookedSlots = snapshot.docs
            .map((doc) => doc.data()['time_slot'] as String)
            .toList();

        // Update availability based on booked slots
        setState(() {
          _availableTimeSlotsMorning = listMorning.map((e) {
            e.isAvailable =
                !bookedSlots.contains('${e.startTime} - ${e.endTime}');
            return e;
          }).toList();
        });
      });
      return;
    }
    // Format the selected date to match the format stored in Firestore
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    // Assuming morningSlots and afternoonSlots are lists of TimeSlot objects
    final listMorning = List<TimeSlot>.from(morningSlots);
    final afternoonList = List<TimeSlot>.from(afternoonSlots);
    // Fetch appointments from Firestore
    await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: formattedDate)
        .where('status', whereIn: ['success', 'inprogress'])
        .where('hospitalId', isEqualTo: widget.medicalId)
        .get()
        .then((snapshot) {
      List<String> bookedSlots = snapshot.docs
          .map((doc) => doc.data()['time_slot'] as String)
          .toList();

      // Update availability based on booked slots
      setState(() {
        _availableTimeSlotsMorning = listMorning.map((e) {
          e.isAvailable =
              !bookedSlots.contains('${e.startTime} - ${e.endTime}');
          return e;
        }).toList();
        _availableTimeSlotsAfternoon = afternoonList.map((e) {
          e.isAvailable =
              !bookedSlots.contains('${e.startTime} - ${e.endTime}');
          return e;
        }).toList();
      });
    });
  }

  List<TimeSlot> convertToTimeSlots(List<String> timeRanges) {
    return timeRanges.map((timeRange) {
      var times = timeRange.split(' - ');
      return TimeSlot(times[0], times[1]);
    }).toList();
  }

  bool isAfternoonSaturdayOrSunday(DateTime date) {
    // Kiểm tra nếu là Chủ Nhật
    if (date.weekday == DateTime.sunday) {
      return true; // Cả ngày Chủ Nhật
    }

    // Kiểm tra nếu là chiều Thứ Bảy
    if (date.weekday == DateTime.saturday) {
      return true; // Chiều Thứ Bảy, từ 12 giờ trưa trở đi
    }

    return false; // Các trường hợp khác
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt Lịch Khám'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  title: 'Quay lại',
                  titleSize: 14,
                  height: 30,
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                CustomButton(
                  title: 'Tiếp theo',
                  titleSize: 14,
                  height: 30,
                  onPressed: () {
                    if (isNext) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable swipe to navigate
              children: <Widget>[
                PagerView1(),
                PagerView2(),
                PagerView3(),
                PagerView4(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PagerView4() {
    return selectedUser != null
        ? Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_selectedDay!)),
                        Text(
                            '${selectedSlot!.startTime} - ${selectedSlot!.endTime}')
                      ],
                    ),
                    subtitle: Text('Khám mới'),
                  ),
                  const Divider(),
                  Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Chi tiết lịch khám',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dịch vụ'),
                          Text('Khám bệnh theo yêu cầu')
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bệnh viện'),
                          Text(selectedMedical?['title'] ?? '')
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Thông tin'),
                          Text(selectedMedical?['description'] ?? '')
                        ],
                      )
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Thông tin bệnh nhân',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Họ và tên'),
                          Text(selectedUser?['name'] ?? '')
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mã bảo hiểm y tế'),
                          Text(selectedUser?['insuranceCard'] ?? '')
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Số điện thoại'),
                          Text(selectedUser?['phone'] ?? '')
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ngày sinh'),
                          Text(selectedUser?['dob'] ?? '')
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedUser?['insuranceCard'].isNotEmpty
                            ? 'Chi phí khám'
                            : 'Chi phí khám tạm tính',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        selectedUser?['insuranceCard'].isNotEmpty
                            ? '0'
                            : '12000 VND',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  !selectedUser?['insuranceCard'].isNotEmpty
                      ? !isPayment
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  width: 300,
                                  title: 'Thanh Toán',
                                  onPressed: () => context
                                      .push(RouterPath.payment)
                                      .then((value) => {
                                            if (value.toString().isNotEmpty)
                                              {
                                                setState(() {
                                                  isPayment = true;
                                                  paymentId =
                                                      value.toString().trim();
                                                }),
                                              }
                                          }),
                                  titleSize: 14,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  title: 'Xác nhận',
                                  width: 300,
                                  onPressed: () async {
                                    CollectionReference appointment =
                                        firestore.collection('appointments');
                                    context.loaderOverlay.show();
                                    await appointment.add({
                                      'date': DateFormat('yyyy-MM-dd')
                                          .format(_selectedDay!),
                                      'time_slot':
                                          '${selectedSlot!.startTime} - ${selectedSlot!.endTime}',
                                      'userId': selectedUser?['userId'],
                                      'amount': 0,
                                      'isDeleted': false,
                                      'hospitalId': widget.medicalId,
                                      'medicalId': selectedUser?.id,
                                      'status': 'inprogress',
                                      'paymentId': paymentId ?? '',
                                    }).then((value) {
                                      context.loaderOverlay.hide();
                                      context.pop();
                                    }).catchError((error) {
                                      context.loaderOverlay.hide();
                                    });
                                  },
                                ),
                              ],
                            )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              title: 'Xác nhận',
                              width: 300,
                              onPressed: () async {
                                CollectionReference appointment =
                                    firestore.collection('appointments');
                                context.loaderOverlay.show();
                                await appointment.add({
                                  'date': DateFormat('yyyy-MM-dd')
                                      .format(_selectedDay!),
                                  'time_slot':
                                      '${selectedSlot!.startTime} - ${selectedSlot!.endTime}',
                                  'userId': selectedUser?['userId'],
                                  'amount': 0,
                                  'isDeleted': false,
                                  'hospitalId': widget.medicalId,
                                  'medicalId': selectedUser?.id,
                                  'status': 'inprogress',
                                  'paymentId': '',
                                }).then((value) {
                                  context.loaderOverlay.hide();
                                  context.pop();
                                }).catchError((error) {
                                  context.loaderOverlay.hide();
                                });
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  // ignore: non_constant_identifier_names
  ListView PagerView2() {
    return ListView(
      children: [
        _availableTimeSlotsMorning.isNotEmpty
            ? buildTimeSlotSection(
                'Buổi sáng',
                _availableTimeSlotsMorning,
              )
            : const SizedBox(),
        _availableTimeSlotsAfternoon.isNotEmpty
            ? buildTimeSlotSection(
                'Buổi Chiều',
                _availableTimeSlotsAfternoon,
              )
            : const SizedBox(),
        const SizedBox(height: 30),
        // CustomButton(
        //   title: 'submit',
        //   onPressed: () async {

        //   },
        // )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  CustomCalender PagerView1() {
    return CustomCalender(
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isBeforeToday(selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
          if (!isNext) {
            setState(() {
              isNext = true;
            });
          }
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          _fetchAvailableTimeSlots(selectedDay);
        }
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
    );
  }

  bool isBeforeToday(DateTime day) {
    return day.isBefore(DateTime.now());
  }

  // ignore: non_constant_identifier_names
  PagerView3() {
    return StreamBuilder(
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
                  DocumentSnapshot document = snapshot
                      .data!.docs[index]; // Get document at the specific index.
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedUser = document;
                        });
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: UserCard(
                        name: document['name'],
                        id: document['insuranceCard'],
                        dob: document['dob'],
                      ),
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }

  Widget buildTimeSlotSection(String title, List<TimeSlot> slots) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return GestureDetector(
                onTap: () {
                  if (slot.isAvailable) {
                    setState(() {
                      selectedSlot = slot;
                    });
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: slot.isAvailable
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedSlot == slot
                              ? Colors.blue
                              : Colors.grey[200],
                          border: Border.all(
                            color: selectedSlot == slot
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${slot.startTime} - ${slot.endTime}',
                          style: TextStyle(
                            color: selectedSlot == slot
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          border: Border.all(
                            color: selectedSlot == slot
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${slot.startTime} - ${slot.endTime}'),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
