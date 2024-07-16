import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/core/widgets/dismiss_key_board.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:koruko_app/utils/debounce.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({
    super.key,
    required this.profileId,
  });
  final String profileId;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final insuranceCardController = TextEditingController();
  final insuranceCardExpiredController = TextEditingController();
  final identificationCardController = TextEditingController();
  final identificationCardExpiredController = TextEditingController();
  final streetAddressController = TextEditingController();

  late String gender = '';

  @override
  void initState() {
    super.initState();
    getUserById(widget.profileId);
  }

  DateTime selectedDate = DateTime.now();
  final Debounce debounce = Debounce(milliseconds: 500);
  String displayedTextErrors = '';
  final user = FirebaseAuthService().currentUser;

  Future<void> selectDate(BuildContext context, controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        helpText: '');
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final medical = firestore.collection('medical').doc(widget.profileId);
      context.loaderOverlay.show();
      await medical.update({
        'userId': user!.uid,
        'name': nameController.text,
        'phone': phoneController.text,
        'dob': dobController.text,
        'identificationCard': identificationCardController.text,
        'identificationCardExpired': identificationCardExpiredController.text,
        'gender': gender,
        'insuranceCard': insuranceCardController.text,
        'insuranceCardExpired': insuranceCardExpiredController.text,
        'streetAddress': streetAddressController.text,
      }).then((value) {
        context.loaderOverlay.hide();
        context.pop();
      }).catchError((error) {
        context.loaderOverlay.hide();
      });
    }
  }

  Future<void> _checkPhoneNumberExists(String phoneNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('medical')
          .where('insuranceCard', isEqualTo: phoneNumber)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          displayedTextErrors = 'Mã bảo hiểm đã tồn tại';
        });
      } else {
        setState(() {
          displayedTextErrors = '';
        });
      }
    } catch (e) {
      setState(() {
        displayedTextErrors = 'Mã bảo hiểm đã tồn tại';
      });
    }
  }

  Future<void> getUserById(String userId) async {
    context.loaderOverlay.show();
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('medical')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        nameController.text = userData['name'];
        phoneController.text = userData['phone'];
        dobController.text = userData['dob'];
        identificationCardController.text = userData['identificationCard'];
        identificationCardExpiredController.text =
            userData['identificationCardExpired'];
        insuranceCardController.text = userData['insuranceCard'];
        insuranceCardExpiredController.text = userData['insuranceCardExpired'];
        streetAddressController.text = userData['streetAddress'];
        setState(() {
          gender = userData['gender'];
        });
      } else {
        print('No user found with id $userId');
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    // ignore: use_build_context_synchronously
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cập nhật hồ sơ bệnh',
        actions: [
          CustomIconButton(
            icon: Icons.save_alt,
            onPressed: () => onSubmit(context),
          )
        ],
      ),
      body: DismissKeyBoard(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                buildTextFormField(
                  nameController,
                  'Họ và Tên',
                  'Please enter your full name',
                ),
                const SizedBox(height: 20),
                buildTextFormField(
                  phoneController,
                  'Số điện thoại',
                  'Please enter your phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                buildDateFormField(
                  dobController,
                  'Ngày sinh*',
                  'Please enter your date of birth',
                ),
                const SizedBox(height: 20),
                buildGenderRadioFormField(),
                const SizedBox(height: 20),
                buildTextFormField(
                  streetAddressController,
                  'Số nhà, tên đường',
                  'Please enter your street address',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: buildTextFormField(
                        insuranceCardController,
                        'Sổ BHYT',
                        'Please enter your health insurance card number',
                        onChanged: (value) async {
                          debounce.run(() {
                            _checkPhoneNumberExists(value);
                          });
                        },
                        isValid: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: buildDateFormField(
                        insuranceCardExpiredController,
                        'Ngày hết hạn',
                        'Please enter your date expired',
                        isValid: false,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: buildTextFormField(
                        identificationCardController,
                        'Số CCCD/CMND',
                        'Please enter your health insurance card number',
                        isValid: false,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: buildDateFormField(
                        identificationCardExpiredController,
                        'Ngày cấp',
                        'Please enter your date expired',
                        isValid: false,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    displayedTextErrors != ''
                        ? Text(
                            displayedTextErrors,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGenderRadioFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Giới tính*',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: buildGenderRadio('Nam', Icons.male),
            ),
            Expanded(
              child: buildGenderRadio('Nữ', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGenderRadio(String genderLabel, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.blueAccent,
          width: 1,
        ),
      ),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon, color: Colors.blueAccent), // Gender icon
            const SizedBox(width: 10), // Space between icon and text
            Text(genderLabel),
          ],
        ),
        leading: Radio<String>(
          value: genderLabel,
          groupValue: gender,
          onChanged: (String? value) {
            setState(() {
              gender = value!;
            });
          },
        ),
      ),
    );
  }

  buildTextFormField(
    TextEditingController controller,
    String label,
    String errorMessage, {
    TextInputType? keyboardType,
    Function(String)? onChanged,
    bool isValid = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label*',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ), // Custom Text Widget for label
        const SizedBox(height: 8), // Space between the label and the text field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: isValid
              ? (value) {
                  if (value!.isEmpty) return errorMessage;
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  buildDateFormField(
    TextEditingController controller,
    String label,
    String errorMessage, {
    bool isValid = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ), // Custom Text Widget for label
        const SizedBox(height: 8), // Space between the label and the text field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly:
              true, // Prevents the keyboard from appearing when the field is tapped
          onTap: () {
            selectDate(context, controller);
          },
          validator: isValid
              ? (value) {
                  if (value!.isEmpty) return errorMessage;
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
