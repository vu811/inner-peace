import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Timer;

// Flip to false when running on a real device.
const TEST_MODE = true;

class HeartRateMonitor {
    private var _callback as Method(hr as Number) as Void;
    private var _timer as Timer.Timer?;
    private var _mockStartTime as Number = 0;

    function initialize(callback as Method(hr as Number) as Void) {
        _callback = callback;
    }

    function start() as Void {
        if (TEST_MODE) {
            _startMock();
        } else {
            Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
            Sensor.enableSensorEvents(method(:_onSensorInfo));
        }
    }

    function stop() as Void {
        if (TEST_MODE) {
            if (_timer != null) {
                (_timer as Timer.Timer).stop();
                _timer = null;
            }
        } else {
            Sensor.enableSensorEvents(null);
        }
    }

    // Called every 3 s by the mock timer.
    // Sends a normal HR for the first 5 s, then elevated to trigger the alert.
    function _onMockTick() as Void {
        var elapsed = System.getTimer() - _mockStartTime;
        _callback.invoke(elapsed > 5000 ? 105 : 68);
    }

    private function _startMock() as Void {
        _mockStartTime = System.getTimer();
        _callback.invoke(68); // immediate resting reading so the screen shows something
        var t = new Timer.Timer();
        _timer = t;
        t.start(method(:_onMockTick), 3000, true);
    }

    // Real sensor callback — sensorInfo.heartRate is the bpm value.
    function _onSensorInfo(sensorInfo as Sensor.Info) as Void {
        var hr = sensorInfo.heartRate;
        if (hr != null) {
            _callback.invoke(hr);
        }
    }
}
