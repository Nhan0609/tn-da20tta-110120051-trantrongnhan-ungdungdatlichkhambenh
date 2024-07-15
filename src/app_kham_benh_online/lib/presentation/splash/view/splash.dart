import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _onPressedLogin(BuildContext context) {
    context.push(RouterPath.login);
  }

  _onPressedRegister(BuildContext context) {
    context.push(RouterPath.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo_tvu.png',
              fit: BoxFit.cover,
              width: 200,
            ),
            const SizedBox(height: 20),
            const SizedBox( 
              width: 300,
              child:  Text(
                'ỨNG DỤNG ĐĂNG KÝ ĐẶT LỊCH KHÁM BỆNH',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 50),
            CustomButton(
              title: 'Đăng nhập',
              onPressed: () => _onPressedLogin(context),
              width: 200,
            ),
            CustomButton(
              title: 'Đăng ký',
              onPressed: () => _onPressedRegister(context),
              width: 200,
              color: Colors.blueGrey[200],
            ),
          ],
        ),
      ),
    );
  }
}
