import 'package:flutter/material.dart';
import 'package:koruko_app/core/widgets/custom_button.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String id;
  final String dob;
  final Function()? onDelete;
  final Function()? onUpdate;

  const UserCard({
    super.key,
    required this.name,
    required this.id,
    required this.dob,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white54,
      elevation: 0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              _getInitials(name),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                onUpdate != null
                    ? CustomIconButton(
                        icon: Icons.edit,
                        onPressed: onUpdate ?? () {},
                        color: Colors.blue,
                      )
                    : const SizedBox(),
                onDelete != null
                    ? CustomIconButton(
                        icon: Icons.delete,
                        onPressed: onDelete ?? () {},
                        color: Colors.red,
                      )
                    : const SizedBox()
              ],
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              id,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dob,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    return nameParts[0][0];
  }
}
