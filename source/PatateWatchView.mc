import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class PatateWatchView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        // var timeFormat = "$1$:$2$";
        // var clockTime = System.getClockTime();
        // var hours = clockTime.hour;
        // if (!System.getDeviceSettings().is24Hour) {
        //     if (hours > 12) {
        //         hours = hours - 12;
        //     }
        // } else {
        //     if (Application.Properties.getValue("UseMilitaryFormat")) {
        //         timeFormat = "$1$$2$";
        //         hours = hours.format("%02d");
        //     }
        // }
        // var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var minutes = clockTime.min.format("%02d");

        var timeString = Lang.format("$1$:$2$", [hours, minutes]);

        // Update screen message
        // var helloYouLabel = View.findDrawableById("HelloYou") as Text;
        // helloYouLabel.setText("Hello You!");

        // Update the date label
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(getDate());

        // Update the heart rate label
        var heartRateLabel = View.findDrawableById("HeartRateLabel") as Text;
        heartRateLabel.setText(getHeartRateString());

        // Update the steps label
        var stepsLabel = View.findDrawableById("StepsLabel") as Text;
        stepsLabel.setText(getStepsString());

        // Update the battery label
        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        batteryLabel.setText(getBatteryString());  

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        drawBatteryBar(dc);

        //drawReferenceLines(dc as Dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function drawReferenceLines(dc as Dc) as Void {
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();

        dc.setPenWidth(1);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(0.2 * WIDTH, 0.1 * HEIGHT, 0.6 * WIDTH, 0.8 * HEIGHT);
        dc.drawRectangle(0.15 * WIDTH, 0.15 * HEIGHT, 0.7 * WIDTH, 0.7 * HEIGHT);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(0.1 * WIDTH, 0.2 * HEIGHT, 0.8 * WIDTH, 0.6 * HEIGHT);
        dc.drawRectangle(0.05 * WIDTH, 0.3 * HEIGHT, 0.9 * WIDTH, 0.4 * HEIGHT);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0.25 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.5 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.75 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0.25 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.1 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.9 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.5 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.75 * WIDTH, 0, 1, HEIGHT);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0.3333 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.6666 * WIDTH, 0, 1, HEIGHT);
    }


    function getDate() as String {
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$",         [
                now.day_of_week,
                now.day,
            ]
        );
    return dateString;
    }

    function getHeartRate() as Number {
        var heartrateIterator = Toybox.ActivityMonitor.getHeartRateHistory(1, true);
        return heartrateIterator.next().heartRate;
    }

    function getHeartRateString() as String {
        var heartrateIterator = Toybox.ActivityMonitor.getHeartRateHistory(1, true);
        var heartRateSample = heartrateIterator.next();

        if (heartRateSample == null || heartRateSample.heartRate == null || heartRateSample.heartRate <= 0) {
            return "--";
        }

        return heartRateSample.heartRate.format("%d");
        }

    function getSteps() as Number or Null {
    return Toybox.ActivityMonitor.getInfo().steps;
    }

    function getStepsString() as String {
        var steps = getSteps();
        if (steps == null) {
            return "-";
        }
        return getSteps().format("%d");
    }

function getBattery() as Float {
    return Toybox.System.getSystemStats().battery;
}

function getBatteryString() as String {
    return getBattery().format("%d") + "%";
}

function drawBatteryBar(dc as Dc) as Void {
    var batteryLevel = getBattery(); 
    var WIDTH = 30;
    var HEIGHT = 12;
    var TIP_WIDTH = 3;
    var TIP_HEIGHT = HEIGHT / 2;
    var x = (dc.getHeight() * 0.45).toNumber(); 
    var y = (dc.getHeight() * 0.15).toNumber(); 

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(x, y, WIDTH, HEIGHT);

    var tipX = x + WIDTH;
    var tipY = y + (HEIGHT - TIP_HEIGHT) / 2;
    dc.fillRectangle(tipX, tipY, TIP_WIDTH, TIP_HEIGHT);

    
    if (batteryLevel < 20) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    } else if (batteryLevel < 50) {
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    } else {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    }

    var fillWidth = ((batteryLevel / 100.0) * (WIDTH - 2)).toFloat();
    dc.fillRectangle(x + 1, y + 1, fillWidth, HEIGHT - 2);
    }

}
