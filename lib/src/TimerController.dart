part of simple_timer;

class TimerController extends AnimationController {

  bool _wasActive = false;

  Duration? _delay;

  TimerController(TickerProvider vsync) : super(vsync: vsync);

  Duration? get delay => _delay;

  /// Sets the animation delay
  void _setDelay(Duration delay) {
    this._delay = delay;
  }

  /// Calculates controller start value from specified duration [startDuration]
  double? _calculateStartValue(Duration? startDuration) {
    startDuration = (startDuration != null && (startDuration > this.duration!)) ? this.duration : startDuration;
    return startDuration == null ? null : (1 - (startDuration.inMilliseconds / this.duration!.inMilliseconds));
  }

  /// This starts the controller animation.
  ///
  /// If [startFrom] is specified, the new value is calculated
  /// and starts from that value, rather than from the [lowerBound]
  void start({bool useDelay = true, Duration? startFrom}) {
    if(useDelay && !_wasActive && (_delay != null)) {
      _wasActive = true;
      Future.delayed(_delay!, () {
        this.forward(from: _calculateStartValue(startFrom));
      });
    } else {
      this.forward(from: _calculateStartValue(startFrom));
    }
  }

  /// This pauses the animation
  void pause() {
    this.stop();
  }

  /// This resets the value back to the [lowerBound]
  @override
  void reset() {
    _wasActive = false;
    super.reset();
  }

  /// This resets and starts the controller animation.
  ///
  /// If [startFrom] is specified, the animation value is calculated
  /// and starts from that value, rather than from the [lowerBound]
  void restart({bool useDelay = true, Duration? startFrom}) {
    this.reset();
    this.start(startFrom: startFrom);
  }

  /// This Reduces the length of time elapsed by the specified duration.
  ///
  /// This doesn't override the initial SimpleTimer widget duration
  /// The specified duration is used to calculate the start value
  ///
  /// The [start] value sets whether or not start the timer after the
  /// value change (defaults to `false`).
  ///
  /// The [animationDuration] value sets the length of time used to animate
  /// from the previous value to the new value
  void add(Duration duration, {bool start = false, Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue = this.value - (duration.inMilliseconds / this.duration!.inMilliseconds);
    this.animateBack(newValue, duration: changeAnimationDuration);
    if (start) {
      this.forward();
    }
  }

  /// This increases the length of time elapsed by the specified duration [duration].
  ///
  /// This doesn't override the initial SimpleTimer widget duration.
  /// The specified duration is used to calculate the start value
  ///
  /// The [start] value sets whether or not start the timer after the
  /// value change (defaults to `false`).
  ///
  /// The [animationDuration] value sets the length of time used to animate
  /// from the previous value to the new value
  void subtract(Duration duration, {bool start = false, Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue = this.value + (duration.inMilliseconds / this.duration!.inMilliseconds);
    this.animateTo(newValue, duration: changeAnimationDuration);
    if (start) {
      this.forward();
    }
  }

}
