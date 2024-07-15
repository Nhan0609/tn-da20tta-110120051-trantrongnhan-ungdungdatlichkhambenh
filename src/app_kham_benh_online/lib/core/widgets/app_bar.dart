import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool hideBackButton;
  final bool isCenterTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.hideBackButton = false,
    this.isCenterTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1560bd).withOpacity(0.8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: isCenterTitle
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            !hideBackButton
                ? IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  )
                : const SizedBox(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions != null
                ? Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions ?? [Container()],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
