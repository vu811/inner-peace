import Toybox.Lang;
import Toybox.System;

class ThresholdDetector {
    private const THRESHOLD = 100;        // bpm; HR must exceed this
    private const CONSECUTIVE_NEEDED = 2; // readings in a row before alerting
    private const COOLDOWN_MS = 60000;    // ms between alerts (prevents spam)

    private var _consecutiveHigh as Number = 0;
    private var _lastAlertTime as Number = 0;

    // Returns true when an alert should fire.
    function evaluate(hr as Number) as Boolean {
        if (hr > THRESHOLD) {
            _consecutiveHigh++;
        } else {
            _consecutiveHigh = 0;
            return false;
        }

        if (_consecutiveHigh < CONSECUTIVE_NEEDED) {
            return false;
        }

        var now = System.getTimer();
        if (now - _lastAlertTime < COOLDOWN_MS) {
            return false;
        }

        _lastAlertTime = now;
        _consecutiveHigh = 0;
        return true;
    }
}
