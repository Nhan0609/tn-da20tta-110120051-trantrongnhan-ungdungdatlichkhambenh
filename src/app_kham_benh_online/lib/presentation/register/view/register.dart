import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/core/widgets/dismiss_key_board.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _subPasswordController = TextEditingController();
  String _role = 'user';
  Map<String, dynamic>? selectedHospital;

  bool isObscured1 = true;
  bool isObscured2 = true;
  IconData iconVisible = Icons.visibility;
  IconData iconInvisible = Icons.visibility_off;

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

  final isShowLoading = true;

  void toggleVisibility1() {
    setState(() {
      isObscured1 = !isObscured1;
    });
  }

  void toggleVisibility2() {
    setState(() {
      isObscured2 = !isObscured2;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
    _subPasswordController.text = '';
  }

  void validation(BuildContext context) {
    if (_subPasswordController.text.trim() == '' ||
        _passwordController.text.trim() == '' ||
        _emailController.text.trim() == '') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Lỗi đăng ký',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
          content: const Text(
            'Thông tin không được để trống!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else if (_subPasswordController.text != _passwordController.text) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Lỗi đăng ký',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
          content: const Text(
            'Mật khẩu không trùng khớp!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      _register(context);
    }
  }

  void _register(BuildContext context) async {
    context.loaderOverlay.show();
    final user = await FirebaseAuthService().signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _role.toString(),
      hospitalId: selectedHospital?['id'].toString() ?? '',
      context: context,
    );
    // ignore: use_build_context_synchronously
    context.loaderOverlay.hide();
    if (user != null) {
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
      // ignore: use_build_context_synchronously
      context.go(RouterPath.home);
    }
    // ignore: use_build_context_synchronously
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Đăng ký'),
      body: DismissKeyBoard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'assets/images/Logo_tvu.png',
                  fit: BoxFit.cover,
                  width: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      suffixIcon: IconButton(
                        icon: Icon(isObscured1 ? iconVisible : iconInvisible),
                        onPressed: toggleVisibility1,
                      ),
                    ),
                    obscureText: !isObscured1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _subPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nhập lại Mật khẩu',
                      suffixIcon: IconButton(
                        icon: Icon(isObscured2 ? iconVisible : iconInvisible),
                        onPressed: toggleVisibility2,
                      ),
                    ),
                    obscureText: !isObscured2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: _role,
                      onChanged: (String? newValue) {
                        setState(() {
                          _role = newValue!;
                        });
                      },
                      items: <String>['user', 'admin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 20),
                    _role == 'admin'
                        ? DropdownButton<Map<String, dynamic>>(
                            hint: Text('Select a hospital'),
                            value: selectedHospital,
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                selectedHospital = newValue;
                              });
                            },
                            items:
                                hospitals.map((Map<String, dynamic> hospital) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: hospital,
                                child: Text(hospital['title']),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  title: 'Đăng ký',
                  onPressed: () => validation(context),
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn đã có tài khoản ?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    CustomTextButton(
                      title: 'Đăng nhập',
                      onPressed: () => context.pop(),
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
