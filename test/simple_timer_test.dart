import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_timer/simple_timer.dart';

void main() {

  group("Progress Text Display", () {

    testWidgets('Default Initial Progress TextDisplay', (WidgetTester tester) async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(getSimpleTimerWidget(timerController));

      // find the SimpleTimer text display widget in the widget tree
      final textDisplayFinder = find.text("0:05");

      // verify that the Text widgets appear exactly once in the widget tree.
      expect(textDisplayFinder, findsOneWidget);
    });

    testWidgets('No Progress Text Display', (WidgetTester tester) async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(getSimpleTimerWithNoTextDisplayWidget(timerController));

      // find the SimpleTimer text display widget in the widget tree
      final textFinder = find.byType(Text);

      // verify that the Text widget does not appear in the widget tree.
      expect(textFinder, findsNothing);
    });

    testWidgets('Count Up Progress Text initial TextDisplay', (WidgetTester tester) async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(getSimpleTimerCountUpWidget(timerController));

      // find the SimpleTimer text display widget in the widget tree
      final textDisplayFinder = find.text("0:00");

      // verify that the Text widget and value appear exactly once in the widget tree.
      expect(textDisplayFinder, findsOneWidget);
    });

    testWidgets('Count Down Timer Progress Text End Value', (WidgetTester tester) async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(getSimpleTimerWidget(timerController));
      timerController.start();
      // continuously build the animated widget until the end of the animation
      await tester.pumpAndSettle();

      // find the SimpleTimer text display widget in the widget tree
      final textDisplayFinder = find.text("0:00");

      // verify that the Text widget and value appear exactly once in the widget tree.
      expect(textDisplayFinder, findsOneWidget);
      // ensure the controller value is now at its upper band
      expect(timerController.value, equals(1));
      // ensure the duration value is still correct
      expect(timerController.duration, equals(Duration(seconds: 5)));
      // ensure the animation has completed
      expect(timerController.status, equals(AnimationStatus.completed));
    });

    testWidgets('Count Up Timer Progress Text End Value', (WidgetTester tester) async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(getSimpleTimerCountUpWidget(timerController));
      timerController.start();
      // continuously animate the widget until the end of the animation
      await tester.pumpAndSettle();

      // find the SimpleTimer text display widget in the widget tree
      final textDisplayFinder = find.text("0:05");

      // verify that the Text widget and value appear exactly once in the widget tree.
      expect(textDisplayFinder, findsOneWidget);
      // ensure the controller value is now at its upper band
      expect(timerController.value, equals(1));
      // ensure the duration value is still correct
      expect(timerController.duration, equals(Duration(seconds: 5)));
      // ensure the animation has completed
      expect(timerController.status, equals(AnimationStatus.completed));
    });

  });

  testWidgets('TimerController Duration is set', (WidgetTester tester) async {
    TimerController timerController = TimerController(const TestVSync());
    await tester.pumpWidget(getSimpleTimerWidget(timerController));

    expect(timerController.duration, equals(Duration(seconds: 5)));
    expect(timerController.delay, equals(Duration()));
  });

  testWidgets('No TimerController/TimerStatus Assert Error', (WidgetTester tester) async {
    // verify that the an Assert Error is thrown during widget initialization.
    expect(() async {
      await tester.pumpWidget(MaterialApp(
        home: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: SimpleTimer(
            duration: const Duration(seconds: 5),
          ),
        ),
      ));
    }, throwsA(isA<AssertionError>()));
  });

  testWidgets('Both TimerController and TimerStatus provided Assert Error', (WidgetTester tester) async {
    // verify that the an Assert Error is thrown during widget initialization.
    expect(() async {
      TimerController timerController = TimerController(const TestVSync());
      await tester.pumpWidget(MaterialApp(
        home: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: SimpleTimer(
            duration: const Duration(seconds: 5),
            controller: timerController,
            status: TimerStatus.pause,
          ),
        ),
      ));
    }, throwsA(isA<AssertionError>()));
  });

}

Widget getSimpleTimerWidget(TimerController timerController) {
  return MaterialApp(
    home: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SimpleTimer(
        duration: const Duration(seconds: 5),
        controller: timerController,
      ),
    ),
  );
}

Widget getSimpleTimerCountUpWidget(TimerController timerController) {
  return MaterialApp(
    home: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SimpleTimer(
        duration: const Duration(seconds: 5),
        controller: timerController,
        progressTextCountDirection: TimerProgressTextCountDirection.count_up,
      ),
    ),
  );
}

Widget getSimpleTimerWithNoTextDisplayWidget(TimerController timerController) {
  return MaterialApp(
    home: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SimpleTimer(
        duration: const Duration(seconds: 5),
        controller: timerController,
        displayProgressText: false,
      ),
    ),
  );
}
