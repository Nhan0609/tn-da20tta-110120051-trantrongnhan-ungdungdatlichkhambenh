import 'package:flutter/material.dart';
import 'package:koruko_app/core/path/string.router.dart';

class GridItem {
  final IconData icon;
  final String text;
  final Color color;
  final String path;

  GridItem(
      {required this.icon,
      required this.text,
      required this.color,
      required this.path});
}

List<GridItem> listGridItem = [
  GridItem(
    icon: Icons.medical_services,
    text: 'Danh sách lịch khám',
    color: Colors.orange,
    path: RouterPath.appointment,
  ),
  GridItem(
    icon: Icons.local_hospital,
    text: 'Đặt lịch khám',
    color: Colors.blue,
    path: RouterPath.listMedicalClinic,
  ),
  GridItem(
    icon: Icons.book_online,
    text: 'Quản lý hồ sơ',
    color: Colors.red,
    path: RouterPath.listProfile,
  ),
  GridItem(
    icon: Icons.message,
    text: 'Giới thiệu ứng dụng',
    color: Colors.teal,
    path: RouterPath.example,
  ),
  GridItem(
    icon: Icons.message,
    text: 'Hướng dẫn sử dụng',
    color: Colors.purple,
    path: RouterPath.introduce,
  ),
  GridItem(
    icon: Icons.assignment_turned_in,
    text: 'Đăng xuất',
    color: Colors.cyan,
    path: '/logout',
  ),
];
