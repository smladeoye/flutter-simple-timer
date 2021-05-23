part of simple_timer;

enum TimerStatus
{
  start,
  pause,
  reset,
}

enum TimerProgressTextCountDirection
{
  count_down,
  count_up,
}

enum TimerProgressIndicatorDirection
{
  clockwise,
  counter_clockwise,
  both
}

// test
enum TimerStyle {
  ring,
  expanding_sector,
  expanding_segment,
  expanding_circle
}