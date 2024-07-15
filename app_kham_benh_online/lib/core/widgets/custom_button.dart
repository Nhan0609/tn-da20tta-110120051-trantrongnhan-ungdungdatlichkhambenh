import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.titleSize, this.titleColor,
  });

  final String title;
  final Function() onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double? titleSize;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(10)), // No border radius
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: titleSize ?? 18,
            color: titleColor ?? Colors.black
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.color,
  });
  final String title;
  final Function() onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: color ?? Colors.black54,
          ),
        ),
      ),
    );
  }
}


class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback onPressed;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.color = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: size,
      color: color,
      onPressed: onPressed,
    );
  }
}