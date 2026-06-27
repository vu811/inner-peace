import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;

// Fires onScheduled(slot) at three fixed daily times:
//   slot 0 = 08:00 (morning)
//   slot 1 = 12:30 (midday)
//   slot 2 = 18:30 (evening)
class MessageScheduler {

    private const TICK_MS = 60000;  // poll every minute

    private var _timer as Timer.Timer;
    private var _onScheduled as Lang.Method;
    // Tracks (hour * 60 + min) of the last slot fired to prevent double-firing
    private var _lastFiredMinutes as Lang.Number;

    function initialize(onScheduled as Lang.Method) {
        _onScheduled = onScheduled;
        _timer = new Timer.Timer();
        _lastFiredMinutes = -1;
    }

    function start() as Void {
        _timer.start(method(:onTick), TICK_MS, true);
    }

    function stop() as Void {
        _timer.stop();
    }

    function onTick() as Void {
        var clock = System.getClockTime();
        var h = clock.hour;
        var m = clock.min;
        var nowMinutes = h * 60 + m;

        // Reset at midnight so each day's slots can fire again
        if (nowMinutes == 0) {
            _lastFiredMinutes = -1;
        }

        if (_lastFiredMinutes == nowMinutes) {
            return;
        }

        var slot = -1;
        if (h == 8 && m == 0) {
            slot = 0;
        } else if (h == 12 && m == 30) {
            slot = 1;
        } else if (h == 18 && m == 30) {
            slot = 2;
        }

        if (slot >= 0) {
            _lastFiredMinutes = nowMinutes;
            _onScheduled.invoke(slot);
        }
    }
}
