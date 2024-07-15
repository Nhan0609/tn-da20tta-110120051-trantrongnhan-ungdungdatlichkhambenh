import 'package:flutter/material.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Giới thiệu ứng dụng',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/image_2.jpg',
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'Giới thiệu ứng dụng:',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 21),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chào mừng bạn đến với Đăng Ký Khám Online! Đây là ứng dụng giúp bạn dễ dàng đặt lịch khám bệnh tại các phòng khám với các tính năng nổi bật.',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        '- Quản lý hồ sơ y tế:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        ' Nơi lưu trữ thông tin ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ],
                  ),
                  const Text(
                    'cá nhân của bạn.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        '- Đặt lịch nhanh chóng:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        ' Chọn phòng khám ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ],
                  ),
                  const Text(
                    'và thời gian phù hợp chỉ với vài bước đơn giản',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        '- Quản lý lịch đăng ký:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        ' Giúp bạn quản lý ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ],
                  ),
                  const Text(
                    'được những đơn đã đăng ký.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        '- Thanh toán trực tuyến: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        'Dễ dàng thanh ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ],
                  ),
                  const Text(
                    'toán qua ứng dụng với nhiều hình thức khác nhau.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    ' Hãy trải nghiệm ngay!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Ứng dụng của chúng tôi cam kết mang đến cho bạn sự tiện lợi và an toàn trong quá trình chăm sóc sức khỏe. Đừng chần chừ, hãy khám phá ngay!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
