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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/tvu_bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hướng dẫn sử dụng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              _buildStep(
                stepNumber: 'Bước 1: ',
                description: 'Cài đặt ứng dụng trên điện thoại.',
              ),
              _buildStep(
                stepNumber: 'Bước 2: ',
                description: 'Nhập tài khoản bằng email mà bạn đã đăng ký để đăng nhập vào ứng dụng.',
              ),
              _buildStep(
                stepNumber: 'Bước 3: ',
                description: 'Tại giao diện Trang chủ, vào mục Quản lý hồ sơ, nhập thông tin cá nhân để tạo hồ sơ bệnh nhân đăng ký khám.',
              ),
              _buildStep(
                stepNumber: 'Bước 4: ',
                description: 'Vào mục Đặt lịch khám, chọn phòng khám, chọn ngày, giờ và chọn hồ sơ bệnh nhân đã tạo ở bước 3 để đăng ký đặt lịch.',
              ),
              _buildStep(
                stepNumber: 'Bước 5: ',
                description: 'Kiểm tra lại thông tin.',
              ),
              const SizedBox(height: 20),
              _buildNote(
                'Trường hợp bệnh nhân',
                ' có bảo hiểm y tế,',
                'sẽ không thanh toán trực tuyến mà sẽ đến quầy tiếp tân để người quản lý quầy tiếp nhận kiểm tra bảo hiểm y tế có hợp lệ hay không.',
              ),
              _buildNote(
                'Trường hợp bệnh nhân',
                ' không có BHYT,',
                'sẽ thanh toán trực tuyến qua ứng dụng, sau khi thanh toán xong, ấn Xác nhận để hoàn thành.',
              ),
              const SizedBox(height: 20),
              _buildWarning(
                'Lưu ý: ',
                'Bệnh nhân phải đến sớm hơn thời gian đã đăng ký 15 phút để quầy tiếp nhận kiểm tra đơn đã đăng ký.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required String stepNumber, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepNumber,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(
      String notePrefix, String noteHighlight, String noteDescription) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: notePrefix,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: noteHighlight,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Text(
            noteDescription,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(String warningPrefix, String warningDescription) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                warningPrefix,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
              Expanded(
                child: Text(
                  warningDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
