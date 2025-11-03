import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String text;
  final bool completed;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double rotation;
  final bool showCheckbox;

  const TaskCard({
    super.key,
    required this.text,
    this.completed = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.rotation = 0,
    this.showCheckbox = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180, // Convert degrees to radians
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showCheckbox)
                        Padding(
                          padding: const EdgeInsets.only(right: 12, top: 2),
                          child: Icon(
                            completed
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 20,
                            color: completed
                                ? Colors.green.shade600
                                : borderColor,
                          ),
                        ),
                      if (!showCheckbox)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: borderColor,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: completed ? Colors.grey : textColor,
                            fontSize: 14,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: Colors.grey,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (onEdit != null || onDelete != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onEdit != null)
                            _ActionButton(
                              icon: Icons.edit,
                              onPressed: onEdit!,
                              color: Colors.grey.shade600,
                            ),
                          if (onEdit != null && onDelete != null)
                            const SizedBox(width: 4),
                          if (onDelete != null)
                            _ActionButton(
                              icon: Icons.delete,
                              onPressed: onDelete!,
                              color: Colors.red.shade600,
                            ),
                        ],
                      ),
                    ),
                  if (completed && showCheckbox)
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade500,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
