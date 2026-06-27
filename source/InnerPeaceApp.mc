import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class InnerPeaceApp extends Application.AppBase {
    private var _view as InnerPeaceView?;
    private var _hrMonitor as HeartRateMonitor?;
    private var _controller as AppController?;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        var controller = new AppController();
        _controller = controller;
        controller.start();

        var monitor = new HeartRateMonitor(method(:onHeartRate));
        _hrMonitor = monitor;
        monitor.start();
    }

    function onStop(state as Dictionary?) as Void {
        if (_hrMonitor != null) {
            (_hrMonitor as HeartRateMonitor).stop();
        }
        if (_controller != null) {
            (_controller as AppController).stop();
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
        if (_controller != null) {
            (_controller as AppController).evaluate(hr);
        }
    }
}

function getApp() as InnerPeaceApp {
    return Application.getApp() as InnerPeaceApp;
}
