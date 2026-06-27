import Toybox.Lang;
import Toybox.Sensor;

class HeartRateMonitor {

    private var _onHeartRate as Lang.Method;

    function initialize(onHeartRate as Lang.Method) {
        _onHeartRate = onHeartRate;
    }

    function start() as Void {
        var options = {
            :period => 1,
            :enabledSensors => [Sensor.SENSOR_HEARTRATE]
        };
        Sensor.registerSensorDataListener(method(:onSensorData), options);
    }

    function stop() as Void {
        Sensor.unregisterSensorDataListener();
    }

    function onSensorData(data as Sensor.SensorData) as Void {
        var hr = data.heartRate;
        if (hr != null) {
            _onHeartRate.invoke(hr);
        }
    }
}
