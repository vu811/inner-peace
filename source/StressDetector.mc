import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.System;

class StressDetector {

    private const HR_THRESHOLD = 100;

    private var _sustainMs as Lang.Number;
    private var _cooldownMs as Lang.Number;
    private var _onStress as Lang.Method;
    private var _elevatedSince as Lang.Number?;
    private var _lastTriggerTime as Lang.Number;

    function initialize(onStress as Lang.Method) {
        _onStress = onStress;
        _elevatedSince = null;

        // Use short windows in TEST_MODE so the alert fires within ~12 s on the simulator.
        if (TEST_MODE) {
            _sustainMs = 6000;
            _cooldownMs = 30000;
        } else {
            _sustainMs = 60000;   // 60 s sustained elevation before alerting
            _cooldownMs = 300000; // 5 min between successive alerts
        }

        _lastTriggerTime = System.getTimer() - _cooldownMs;
    }

    function evaluate(bpm as Lang.Number) as Void {
        var now = System.getTimer();

        if (bpm >= HR_THRESHOLD) {
            if (_elevatedSince == null) {
                _elevatedSince = now;
            } else if ((now - (_elevatedSince as Lang.Number)) >= _sustainMs) {
                if ((now - _lastTriggerTime) >= _cooldownMs && _isInactive()) {
                    _elevatedSince = null;
                    _lastTriggerTime = now;
                    _onStress.invoke();
                }
            }
        } else {
            _elevatedSince = null;
        }
    }

    private function _isInactive() as Lang.Boolean {
        // Always treat as inactive in test mode — no need for ActivityMonitor.
        if (TEST_MODE) {
            return true;
        }
        try {
            var info = ActivityMonitor.getInfo();
            return info.moveBarLevel > 0;
        } catch (ex instanceof Lang.Exception) {
            return true;
        }
    }
}
