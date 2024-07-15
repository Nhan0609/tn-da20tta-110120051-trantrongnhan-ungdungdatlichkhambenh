import 'package:flutter/material.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';

class IntroDuceScreen extends StatefulWidget {
  const IntroDuceScreen({super.key});

  @override
  State<IntroDuceScreen> createState() => _IntroDuceScreenState();
}

class _IntroDuceScreenState extends State<IntroDuceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Hướng dẫn sử dụng',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/image_1.jpg',
                fit: BoxFit.cover,
              ),
              const Text(
                'Hướng dẫn sử dụng',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 21),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Bước 1: ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    'Cài đặt ứng dụng trên điện thoại.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Bước 2:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    ' Nhập tài khoản bằng email ',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
              const Text(
                'mà bạn đã đăng ký để đăng nhập vào ứng dụng.',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Bước 3: ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    ' Tại giao diện Trang chủ, vào mục ',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
              const Text(
                'Quản lý hồ sơ, nhập thông tin cá nhân',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const Text(
                'để tạo hồ sơ bệnh nhân đăng ký khám.',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Bước 4: ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    ' Vào mục Đặt lịch khám, chọn',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
              const Text(
                ' phòng khám, chọn ngày, giờ và chọn hồ sơ bệnh nhân đã tạo ở bước 3 để đăng ký đặt lịch. ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Bước 5: ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    'Kiểm tra lại thông tin.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Trường hợp bệnh nhân',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    ' có bảo hiểm y tế,',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.red),
                  ),
                ],
              ),
              const Text(
                'sẽ không thanh toán trực tuyến mà sẽ đến quầy tiếp tân để người quản lý quầy tiếp nhận kiểm tra bảo hiểm y tế có hợp lệ hay không.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Trường hợp bệnh nhân',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    ' không có BHYT,',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.red),
                  ),
                ],
              ),
              const Text(
                'sẽ thanh toán trực tuyến qua ứng dụng, sau khi thanh toán xong, ấn Xác nhận để hoàn thành.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Lưu ý: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.redAccent,
                    ),
                  ),
                  Text(
                    'bệnh nhân phải đến sớm hơn thời ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const Text(
                'gian đã đăng ký 15 phút để quầy tiếp nhận kiểm tra đơn đã đăng ký.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
