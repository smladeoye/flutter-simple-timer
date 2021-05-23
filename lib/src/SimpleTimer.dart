part of simple_timer;


/// A Simple Timer Widget
///
/// The timer will take the size of its parent
class SimpleTimer extends StatefulWidget {

  /// Creates a Simple Timer with animated progress indicator
  SimpleTimer({
    Key? key,
    required this.duration,
    this.onStart,
    this.onEnd,
    this.valueListener,
    this.progressTextFormatter,
    this.controller,
    this.status,
    this.progressTextStyle,
    this.delay = const Duration(seconds: 0),
    this.timerStyle = TimerStyle.ring,
    this.displayProgressIndicator = true,
    this.displayProgressText = true,
    this.progressTextCountDirection = TimerProgressTextCountDirection.count_down,
    this.progressIndicatorDirection = TimerProgressIndicatorDirection.clockwise,
    this.backgroundColor = Colors.grey,
    this.progressIndicatorColor = Colors.green,
    this.startAngle = Math.pi * 1.5,
    this.strokeWidth = 5.0,
  }):assert(!(status == null && controller == null), "No Controller or Status has been set; Please set either the controller (TimerController) or the status (TimerStatus) property - only should can be set"),
        assert(status == null || controller == null, "Both Controller and Status have been set; Please set either the controller (TimerController) or the status (TimerStatus) - only one should be set"),
        assert(displayProgressIndicator || displayProgressText,
        "At least either displayProgressText or displayProgressIndicator must be set to True"),
        super(key: key);

  /// The length of time for this timer.
  final Duration duration;

  /// The length of time to delay the start / animation of the timer.
  ///
  /// Defaults to `Duration(seconds: 0)`
  final Duration delay;

  /// Controls the status of the timer.
  ///
  /// If provided, status should be null - ensure you dispose of it
  /// when done. If null, this widget will create its own [TimerController]
  /// and dispose it when the widget is disposed.
  final TimerController? controller;

  /// The current status of the timer.
  ///
  /// This can also be used to control this timer instead of a controller
  /// but providing a controller would be preferable.
  /// If provided, controller should be null
  final TimerStatus? status;

  /// The display style for this timer.
  ///
  /// The look of the displayed widget is changed based on the selected style.
  /// Defaults to [TimerStyle.ring]
  final TimerStyle timerStyle;

  /// A callback function to format the text displayed by this Timer.
  ///
  /// This callback function is passed the a [Duration] (either time left
  /// or time elapsed) which is determined by the [progressTextCountDirection]
  final String Function(Duration timeElapsed)? progressTextFormatter;

  /// The callback function executed when the timer starts counting.
  ///
  /// The timer starts counting after the [delay]
  final VoidCallback? onStart;

  /// The callback function executed when the timer has finished counting.
  ///
  /// The is only called when the timer has completed the length of its running duration
  final VoidCallback? onEnd;

  /// The callback function executed for each change in the time elapsed by the timer.
  ///
  /// This callback function is passed a [Duration] (either time left
  /// or time elapsed) which is determined by the [progressTextDisplayDirection]
  final void Function(Duration timeElapsed)? valueListener;

  /// The counting direction (counting up or counting down) of the text displayed by the timer.
  final TimerProgressTextCountDirection progressTextCountDirection;

  /// The rotating direction of this timer's progress indicator.
  ///
  /// Defaults to [TimerProgressIndicatorDirection.clockwise]
  final TimerProgressIndicatorDirection progressIndicatorDirection;

  /// Sets whether to display the progress text.
  ///
  /// At least either this or [displayProgressIndicator] must be set as true
  /// Defaults to true.
  final bool displayProgressText;

  /// The TextStyle applied to the progress text.
  final TextStyle? progressTextStyle;

  /// Sets whether to display the progress text.
  ///
  /// At least either this or [displayProgressText] must be set as true
  /// Defaults to true.
  final bool displayProgressIndicator;

  /// The color of the animating progress indicator.
  final Color progressIndicatorColor;

  /// The background color of the inner shape (circle) of the timer
  final Color backgroundColor;

  /// The start angle of the progress indicator.
  ///
  /// The value is in radian.
  /// Defaults to `Math.pi * 1.5` - At the top
  final double startAngle;

  /// The width of the brush stroke used to paint this timer's shape.
  ///
  /// Defaults to `5.0`
  final double strokeWidth;

  @override
  State<StatefulWidget> createState() {
    return TimerState();
  }
}

class TimerState extends State<SimpleTimer> with SingleTickerProviderStateMixin {

  /// This timer's animation controller.
  ///
  /// This is indirectly referenced by the widget status [widget.status]
  /// and controls when the timer is started [TimerStatus.start], paused
  /// [TimerStatus.pause] or reset [TimerStatus.reset]
  late TimerController controller;

  bool _useLocalController = false;

  /// Sets `true` if the timer has started running.
  ///
  /// This is used to know when to apply the delay; If the timer not been
  /// started (when created or reset) then the delay is applied, but if it
  /// has ever been started then no delay is applied again at any point when
  /// it is paused and started
  bool wasActive = false;

  @override
  void initState() {
    if(widget.controller == null) {
      controller = TimerController(this);
      _useLocalController = true;
    } else {
      controller = widget.controller!;
    }
    controller.duration = widget.duration;
    controller._setDelay(widget.delay);
    controller.addListener(_animationValueListener);
    controller.addStatusListener(_animationStatusListener);
    if(_useLocalController && (widget.status == TimerStatus.start)) {
      _startTimer(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:  Align(
            alignment: FractionalOffset.center,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  widget.displayProgressIndicator ?
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return CustomPaint(
                        size: MediaQuery.of(context).size,
                        painter: TimerPainter(
                            animation: controller,
                            timerStyle: widget.timerStyle,
                            progressIndicatorDirection: widget.progressIndicatorDirection,
                            progressIndicatorColor: widget.progressIndicatorColor,
                            backgroundColor: widget.backgroundColor,
                            startAngle: widget.startAngle,
                            strokeWidth: widget.strokeWidth
                        ),
                      );
                    },
                  ) : Container(),
                  widget.displayProgressText ? Container(
                    margin: const EdgeInsets.all(5),
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return Text(getProgressText(), style: getProgressTextStyle());
                            }
                        ),
                      ),
                    ),
                  ) : Container()
                ],
              ),
            )
        )
    );
  }

  TextStyle getProgressTextStyle() {
    return TextStyle(fontSize: Theme.of(context).textTheme.headline1!.fontSize).merge(widget.progressTextStyle);
  }

  @override
  void didUpdateWidget(SimpleTimer oldWidget) {
    if (_useLocalController) {
      if (widget.status == TimerStatus.start && oldWidget.status != TimerStatus.start) {
        if (controller.isDismissed) {
          _startTimer();
        } else {
          _startTimer(false);
        }
      } else if (widget.status == TimerStatus.pause && oldWidget.status != TimerStatus.pause) {
        controller.pause();
      } else if (widget.status == TimerStatus.reset && oldWidget.status != TimerStatus.reset) {
        controller.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startTimer([bool useDelay = true]) {
    if(useDelay && !controller._wasActive) {
      controller._wasActive = true;
      Future.delayed(widget.delay, () {
        if(mounted && (widget.status == TimerStatus.start)) {
          controller.forward();
        }
      });
    } else {
      controller.forward();
    }
  }

  void _animationValueListener() {
    if(widget.valueListener != null) {
      widget.valueListener!(controller.duration! * controller.value);
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    if(status == AnimationStatus.forward && widget.onStart != null) {
      wasActive = true;
      widget.onStart!();
    } else if(status == AnimationStatus.completed && widget.onEnd != null) {
      widget.onEnd!();
    } else if(status == AnimationStatus.dismissed) {
      wasActive = false;
    }
  }

  String getProgressText() {
    Duration duration = controller.duration! * controller.value;
    if(widget.progressTextCountDirection == TimerProgressTextCountDirection.count_down) {
      duration = Duration(seconds: controller.duration!.inSeconds - duration.inSeconds);
    }
    if(widget.progressTextFormatter == null) {
      return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}";
    }
    return widget.progressTextFormatter!(duration);
  }

  @override
  void dispose() {
    controller.stop();
    controller.removeStatusListener(_animationStatusListener);
    if(_useLocalController) {
      controller.dispose();
    }
    super.dispose();
  }
}

