import 'package:flutter/material.dart';

class HomeListTile extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final bool showArrow;
  final Function onTileClicked;

  const HomeListTile(
      {Key? key,
      required this.title,
      this.description,
      required this.icon,
      required this.showArrow,
      required this.onTileClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (description != null)
                  Text(
                    description as String,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            leading: Icon(icon),
            trailing: showArrow ? const Icon(Icons.chevron_right) : null,
            onTap: () => onTileClicked()),
        const Divider()
      ],
    );
  }
}
