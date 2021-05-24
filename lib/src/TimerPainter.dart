part of simple_timer;

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  TimerProgressIndicatorDirection progressIndicatorDirection;
  TimerStyle timerStyle;
  Color progressIndicatorColor, backgroundColor;
  double startAngle;
  double strokeWidth;

  TimerPainter({
    required this.animation,
    this.progressIndicatorDirection = TimerProgressIndicatorDirection.clockwise,
    this.progressIndicatorColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.timerStyle = TimerStyle.ring,
    this.startAngle = Math.pi * 1.5,
    this.strokeWidth = 5.0
  }) : super(repaint: animation);

  PaintingStyle getPaintingStyle() {
    switch(timerStyle) {
      case TimerStyle.ring:
        return PaintingStyle.stroke;
      case TimerStyle.expanding_sector:
        return PaintingStyle.fill;
      case TimerStyle.expanding_circle:
        return PaintingStyle.fill;
      case TimerStyle.expanding_segment:
        return PaintingStyle.fill;
      default:
        timerStyle = TimerStyle.ring;
        return PaintingStyle.stroke;
    }
  }

  double getProgressRadius(double circleRadius) {
    if(timerStyle == TimerStyle.expanding_circle) {
      circleRadius = circleRadius * animation.value;
    }
    return circleRadius;
  }

  double getProgressSweepAngle() {
    double progress = 2 * Math.pi;
    if(timerStyle == TimerStyle.expanding_circle) {
      return progress;
    }
    progress = animation.value * progress;
    if (progressIndicatorDirection == TimerProgressIndicatorDirection.counter_clockwise) {
      progress = -progress;
    }
    return progress;
  }

  double getStartAngle() {
    if (progressIndicatorDirection == TimerProgressIndicatorDirection.both) {
      return (startAngle - (Math.pi * animation.value)).abs();
    }
    return startAngle;
  }

  bool shouldUseCircleCenter() {
    if(timerStyle == TimerStyle.ring) {
      return false;
    } else if(timerStyle == TimerStyle.expanding_segment) {
      return false;
    }
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = Math.min(size.width, size.height) / 2;
    final Offset center = size.center(Offset.zero);
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = getPaintingStyle();

    canvas.drawCircle(center, radius, paint);

    Rect rect = Rect.fromCircle(center: center, radius: getProgressRadius(radius));
    paint.color = progressIndicatorColor;
    canvas.drawArc(rect, getStartAngle(), getProgressSweepAngle(), shouldUseCircleCenter(), paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        oldDelegate.progressIndicatorColor != progressIndicatorColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}