# Timer

A Simple Timer Widget with various customizable options

## Installing

To Start using this library include **timer** as a dependency in your **puspec.yaml** file. 
Make sure to include the latest version

## Usage

To use the widget, import the package in your project and include the widget like below:


 Container(
    child: Timer(
     		controller: _timerController,
     		duration: Duration(seconds: 10),
     		timerStyle: TimerStyle.ring,
     		backgroundColor: Colors.grey,
      		progressIndicatorColor: Colors.green
      		)
	  )

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
