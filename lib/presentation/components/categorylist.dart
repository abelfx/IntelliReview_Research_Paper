import 'package:flutter/material.dart';

class GridLogoWithActions extends StatelessWidget {
  final String text;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GridLogoWithActions({
    Key? key,
    required this.text,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // White Grid Logo
          const Icon(Icons.grid_on, color: Colors.white),
          const SizedBox(width: 12),
          
          // White Text
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          
          // Black Edit Icon (optional)
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onEdit,
            ),
          
          // Black Delete Icon (optional)
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}