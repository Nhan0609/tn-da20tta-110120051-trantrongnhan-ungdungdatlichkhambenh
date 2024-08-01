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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/slideshow2.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Giới thiệu ứng dụng:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Chào mừng bạn đến với Đăng Ký Khám Online! Đây là ứng dụng giúp bạn dễ dàng đặt lịch khám bệnh tại các phòng khám với các tính năng nổi bật.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildFeature(
                title: 'Quản lý hồ sơ y tế:',
                description: 'Nơi lưu trữ thông tin cá nhân của bạn.',
              ),
              _buildFeature(
                title: 'Đặt lịch nhanh chóng:',
                description: 'Chọn phòng khám và thời gian phù hợp chỉ với vài bước đơn giản.',
              ),
              _buildFeature(
                title: 'Quản lý lịch đăng ký:',
                description: 'Giúp bạn quản lý được những đơn đã đăng ký.',
              ),
              _buildFeature(
                title: 'Thanh toán trực tuyến:',
                description: 'Dễ dàng thanh toán qua ứng dụng với nhiều hình thức khác nhau.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Hãy trải nghiệm ngay!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Ứng dụng của chúng tôi cam kết mang đến cho bạn sự tiện lợi và an toàn trong quá trình chăm sóc sức khỏe. Đừng chần chừ, hãy khám phá ngay!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
