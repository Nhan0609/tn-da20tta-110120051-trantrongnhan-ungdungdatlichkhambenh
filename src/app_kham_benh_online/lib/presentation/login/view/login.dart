import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';
import 'package:koruko_app/core/widgets/dismiss_key_board.dart';
import 'package:koruko_app/service/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isObscured = true;
  IconData iconVisible = Icons.visibility;
  IconData iconInvisible = Icons.visibility_off;

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
  }

  void toggleVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  void _login(BuildContext context) async {
    context.loaderOverlay.show();
    final user = await FirebaseAuthService().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      context: context,
    );

    if (user != null) {
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
      // ignore: use_build_context_synchronously
    }
    // ignore: use_build_context_synchronously
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Đăng nhập',
      ),
      body: DismissKeyBoard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'assets/images/Logo_tvu.png',
                  fit: BoxFit.cover,
                  width: 200,
                ),
                const SizedBox(height: 50),
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
                        icon: Icon(isObscured ? iconVisible : iconInvisible),
                        onPressed: toggleVisibility,
                      ),
                    ),
                    obscureText: isObscured,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomTextButton(
                      title: 'Quên mật khẩu?',
                      onPressed: _forgotPassword,
                    )
                  ],
                ),
                CustomButton(
                  title: 'Đăng nhập',
                  onPressed: () => _login(context),
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn chưa có tài khoản ?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    CustomTextButton(
                      title: 'Đăng ký',
                      onPressed: () => context.push(RouterPath.register),
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

  _forgotPassword() {}
}
