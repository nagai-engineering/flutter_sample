import 'package:flutter/material.dart';

class TipBubble extends StatelessWidget {
  final String emoji;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;

  const TipBubble({
    super.key,
    required this.emoji,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emoji avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                borderColor.withValues(alpha: 0.8),
                borderColor.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Bubble
        Expanded(
          child: CustomPaint(
            painter: _BubblePainter(
              backgroundColor: backgroundColor,
              borderColor: borderColor,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;

  _BubblePainter({
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const radius = 16.0;
    const tailWidth = 10.0;
    const tailHeight = 8.0;
    const tailPosition = 12.0;

    // Start from top-left (after tail)
    path.moveTo(0, tailPosition + tailHeight + radius);
    path.lineTo(0, tailPosition + tailHeight);

    // Tail triangle
    path.lineTo(-tailWidth, tailPosition + tailHeight / 2);
    path.lineTo(0, tailPosition);

    // Top-left corner
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: const Radius.circular(radius),
    );

    // Top-right corner
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );

    // Bottom-right corner
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );

    // Bottom-left corner
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => false;
}
