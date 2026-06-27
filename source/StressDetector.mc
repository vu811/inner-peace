import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.System;

class StressDetector {

    // bpm that, when sustained, suggests stress rather than exercise
    private const HR_THRESHOLD = 100;
    // HR must stay elevated for this long before triggering (ms)
    private const SUSTAIN_MS = 60000;
    // Minimum gap between successive stress events (ms)
    private const COOLDOWN_MS = 300000;

    private var _onStress as Lang.Method;
    private var _elevatedSince as Lang.Number?;
    private var _lastTriggerTime as Lang.Number;

    function initialize(onStress as Lang.Method) {
        _onStress = onStress;
        _elevatedSince = null;
        // initialise far enough in the past that the first detection can fire immediately
        _lastTriggerTime = System.getTimer() - COOLDOWN_MS;
    }

    function evaluate(bpm as Lang.Number) as Void {
        var now = System.getTimer();

        if (bpm >= HR_THRESHOLD) {
            if (_elevatedSince == null) {
                _elevatedSince = now;
            } else if ((now - _elevatedSince) >= SUSTAIN_MS) {
                if ((now - _lastTriggerTime) >= COOLDOWN_MS && isInactive()) {
                    _elevatedSince = null;
                    _lastTriggerTime = now;
                    _onStress.invoke();
                }
            }
        } else {
            // Any dip below the threshold resets the sustained window
            _elevatedSince = null;
        }
    }

    // Returns true when the user appears sedentary (move bar > 0 means not recently active).
    // Falls back to true so detection still works if ActivityMonitor is unavailable.
    private function isInactive() as Lang.Boolean {
        try {
            var info = ActivityMonitor.getInfo();
            return info.moveBarLevel > 0;
        } catch (ex instanceof Lang.Exception) {
            return true;
        }
    }
}
