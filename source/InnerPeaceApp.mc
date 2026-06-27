import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class InnerPeaceApp extends Application.AppBase {
    private var _view as InnerPeaceView?;
    private var _hrMonitor as HeartRateMonitor?;
    private var _detector as ThresholdDetector?;
    private var _promptService as CalmPromptService?;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        _detector = new ThresholdDetector();
        _promptService = new CalmPromptService();
        var monitor = new HeartRateMonitor(method(:onHeartRate));
        _hrMonitor = monitor;
        monitor.start();
    }

    function onStop(state as Dictionary?) as Void {
        if (_hrMonitor != null) {
            (_hrMonitor as HeartRateMonitor).stop();
        }
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new InnerPeaceView();
        _view = view;
        return [view, new InnerPeaceDelegate()];
    }

    function onHeartRate(hr as Number) as Void {
        if (_view != null) {
            (_view as InnerPeaceView).setHeartRate(hr);
        }
        var detector = _detector;
        if (detector != null && detector.evaluate(hr)) {
            var service = _promptService;
            var prompt = service != null ? service.nextPrompt() : "Breathe slowly";
            WatchUi.pushView(new BreathingView(prompt), new BreathingDelegate(), WatchUi.SLIDE_UP);
        }
    }
}

function getApp() as InnerPeaceApp {
    return Application.getApp() as InnerPeaceApp;
}
