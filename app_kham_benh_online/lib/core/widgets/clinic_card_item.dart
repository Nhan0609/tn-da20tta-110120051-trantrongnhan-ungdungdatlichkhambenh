import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';

import 'custom_button.dart';

class ClinicInfoCard extends StatelessWidget {
  const ClinicInfoCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.address,
    required this.id,
  });
  final String image;
  final String title;
  final String description;
  final String address;
  final String id;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                image,
                width: 80,
              ), // Make sure to add your logo in assets
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 259,
                    child: Text(
                      description,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 10),
              SizedBox(
                width: mWidth,
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                title: 'Đặt lịch ngay',
                onPressed: () {
                  context.push(RouterPath.registerCalender.replaceAll(
                    ':id',
                    id,
                  ));
                },
                titleSize: 14,
              ),
            ],
          )
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.blue,
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          //     ),
          //     child: const Text('Đặt lịch ngay', style: TextStyle(color: Colors.white),),
          //   ),
          // ),
        ],
      ),
    );
  }
}
