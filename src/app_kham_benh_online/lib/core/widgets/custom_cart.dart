import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
