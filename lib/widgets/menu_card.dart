import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const MenuCard({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    margin: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
