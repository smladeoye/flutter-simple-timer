import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Simple Timer Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection = TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection = TimerProgressTextCountDirection.count_down;


  @override
  void initState() {
    // initialize timercontroller
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: SimpleTimer(
                    duration: const Duration(seconds: 5),
                    controller: _timerController,
                    timerStyle: _timerStyle,
                    onStart: handleTimerOnStart,
                    onEnd: handleTimerOnEnd,
                    valueListener: timerValueChangeListener,
                    backgroundColor: Colors.grey,
                    progressIndicatorColor: Colors.green,
                    progressIndicatorDirection: _progressIndicatorDirection,
                    progressTextCountDirection: _progressTextCountDirection,
                    progressTextStyle: TextStyle(color: Colors.black),
                    strokeWidth: 10,
                  ),
                )
            ),
            Column(
              children: <Widget>[
                const Text("Timer Status", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: _timerController.start,
                      child: const Text("Start", style: TextStyle(color: Colors.white)),
                      color: Colors.green,
                    ),
                    FlatButton(
                      onPressed: _timerController.pause,
                      child: const Text("Pause", style: TextStyle(color: Colors.white)),
                      color: Colors.blue,
                    ),
                    FlatButton(
                      onPressed: _timerController.reset,
                      child: const Text("Reset", style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                    ),
                    FlatButton(
                      onPressed: _timerController.restart,
                      child: const Text("Restart", style: TextStyle(color: Colors.white)),
                      color: Colors.orange,
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                const Text("Timer Style", style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                        child: FlatButton(
                            onPressed: ()=>_setStyle(TimerStyle.ring),
                            color: Colors.blue,
                            child:  const Text("Ring",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white)
                            )
                        )
                    ),
                    Flexible(
                      child: FlatButton(
                          onPressed: ()=>_setStyle(TimerStyle.expanding_circle),
                          color: Colors.green,
                          child: const Text("Expanding Circle",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)
                          )
                      ),
                    ),
                    Flexible(
                      child: FlatButton(
                          onPressed: ()=>_setStyle(TimerStyle.expanding_sector),
                          color: Colors.orange,
                          child: const Text("Expanding Sector",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)
                          )
                      ),
                    ),
                    Flexible(
                      child: FlatButton(
                          onPressed: ()=>_setStyle(TimerStyle.expanding_segment),
                          color: Colors.red,
                          child: const Text("Expanding Segment",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)
                          )
                      ),
                    )
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                const Text("Timer Count Direction", style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: ()=>_setCountDirection(TimerProgressTextCountDirection.count_up),
                      color: Colors.blue,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Flexible(
                              child: const Text("Count Up",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)
                              )
                          ),
                          Flexible(child: Icon(Icons.arrow_upward, size: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: ()=>_setCountDirection(TimerProgressTextCountDirection.count_down),
                      color: Colors.orange,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Flexible(
                              child: const Text("Count Down",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)
                              )
                          ),
                          Icon(Icons.arrow_downward, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                const Text("Timer Progress Indicator Direction", style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: ()=>_setProgressIndicatorDirection(TimerProgressIndicatorDirection.clockwise),
                      color: Colors.blue,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Flexible(
                              child: const Text("Clockwise",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)
                              )
                          ),
                          Flexible(child: Icon(Icons.subdirectory_arrow_left, size: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: ()=>_setProgressIndicatorDirection(TimerProgressIndicatorDirection.counter_clockwise),
                      color: Colors.orange,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Flexible(
                              child: const Text("Counter Clockwise",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)
                              )
                          ),
                          Icon(Icons.subdirectory_arrow_right, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        )
      ),
    );
  }

  void _setCountDirection(TimerProgressTextCountDirection countDirection) {
    setState(() {
      _progressTextCountDirection = countDirection;
    });
  }

  void _setProgressIndicatorDirection(TimerProgressIndicatorDirection progressIndicatorDirection) {
    setState(() {
      _progressIndicatorDirection = progressIndicatorDirection;
    });
  }

  void _setStyle(TimerStyle timerStyle) {
    setState(() {
      _timerStyle = timerStyle;
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {

  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }
}
