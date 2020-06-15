# SimpleTimer

A Timer Widget with various customizable options

## Installing

To Start using this library include **simple_timer** as a dependency in your **puspec.yaml** file. 
Make sure to include the latest version

## Usage

To use the widget, import the package in your project

```
import 'package:simple_timer/simple_timer.dart';
```

The timer can be controlled in two ways:
* **Using a TimerController (preferred)** - The TimerController is a convenience wrapper (subclass) of an AnimationController and needs a TickerProvider, so be sure to **extend a TickerProvider in your class**. Declare and instantiate your timer controller like below:

    ```
    // declaration
    TimerController _timerController;

    // instantiation
    _timerController = TimerController(this);
    ```
    **Note: Remember to dispose the TimerController**

    and set the controller property to the TimerController object like below:

    ```
    Container(
        child: SimpleTimer(
            controller: _timerController,
            duration: Duration(seconds: 10),
        )
    )
    ```
    Call the TimerController start method (**_timerController.start()**) to start the timer, 
    the pause method (**_timerController.pause()**) to pause the timer, 
    the reset method (**_timerController.reset()**) to reset the timer and 
    the restart method (**_timerController.restart()**) to restart the timer.

* **Setting the Status** - The timer can also be controler by passing a **TimerStatus** value to the status property; like below:
    ```
    Container(
        child: SimpleTimer(
            status: TimerStatus.start,
            duration: Duration(seconds: 10),
        )
    )
    ```
**Note: The SimpleTimer widget uses its parent size.**

### Customizable Options
There are various customizable options provided by the SimpleTimer widget, see below:


<table>
<thead>
	<tr>
		<th>Property</th>
		<th>Description</th>
		<th>Value Type</th>
		<th>Default Value</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>duration</td>
		<td>The duration of the timer</td>
		<td>Duration</td>
		<td></td>
	</tr>
	<tr>
		<td>controller</td>
		<td>A TimerController to control the timer. If this is provided then status must be null.</td>
		<td>TimerController</td>
		<td></td>
	</tr>
	<tr>
		<td>status</td>
		<td>An alternative to the controller that sets the status of the timer. If provided, controller must be null</td>
		<td>TimerStatus</td>
		<td></td>
	</tr>
	<tr>
		<td>timerStyle</td>
		<td>Sets the look of the animated timer widget</td>
		<td>TimerStyle</td>
		<td>ring</td>
	</tr>
	<tr>
		<td>delay</td>
		<td>Sets a start delay for timer - i.e. delays the start of the timer by the specified duration</td>
		<td>Duration</td>
		<td>Duration(seconds: 0)</td>
	</tr>
	<tr>
		<td>backgroundColor</td>
		<td>The background color of the inner shape (circle) of the timer</td>
		<td>Color</td>
		<td>grey</td>
	</tr>
	<tr>
		<td>progressIndicatorColor</td>
		<td>The color of the animating progress indicator.</td>
		<td>Color</td>
		<td>green</td>
	</tr>
	<tr>
		<td>progressIndicatorDirection</td>
		<td>The rotating direction of the timer&#39;s progress indicator</td>
		<td>TimerProgressIndicatorDirection</td>
		<td>clockwise</td>
	</tr>
	<tr>
		<td>displayProgressIndicator</td>
		<td>Sets whether to show the progress indicator</td>
		<td>bool</td>
		<td>true</td>
	</tr>
	<tr>
		<td>displayProgressText</td>
		<td>Sets whether to show the progress text</td>
		<td>bool</td>
		<td>true</td>
	</tr>
	<tr>
		<td>progressTextStyle</td>
		<td>The TextStyle used by the progress text.</td>
		<td>TextStyle</td>
		<td></td>
	</tr>
	<tr>
		<td>progressTextCountDirection</td>
		<td>The counting direction of the text displayed by the timer</td>
		<td>TimerProgressTextCountDirection</td>
		<td>count_down</td>
	</tr>
	<tr>
		<td>progressTextFormatter</td>
		<td>A callback function to format the text displayed by this Timer.</td>
		<td>String Function(Duration)</td>
		<td>displays duration in MM:SS format</td>
	</tr>
	<tr>
		<td>onStart</td>
		<td>Callback executed when the timer starts counting</td>
		<td>VoidCallback</td>
		<td></td>
	</tr>
	<tr>
		<td>onEnd</td>
		<td>Callback executed when the timer has finished counting</td>
		<td>VoidCallback</td>
		<td></td>
	</tr>
	<tr>
		<td>valueListener</td>
		<td>The callback executed for each change in the time elapsed</td>
		<td>void Function(Duration)</td>
		<td></td>
	</tr>
</tbody>
</table>

## Demo - Controlling the Timer Status
![simple_timer_demo_01](https://user-images.githubusercontent.com/12571220/84502612-9c04c000-acb0-11ea-83d7-55ab37e04dd4.gif)

## Demo - Customizable options
![simple_timer_demo_02](https://user-images.githubusercontent.com/12571220/84502994-467ce300-acb1-11ea-9d92-90bbfe7bcf01.gif)
