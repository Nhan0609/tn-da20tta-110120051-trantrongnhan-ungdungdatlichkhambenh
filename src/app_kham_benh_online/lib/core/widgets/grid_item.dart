import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  const GridViewItem({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 36, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
