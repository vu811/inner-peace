import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class InnerPeaceApp extends Application.AppBase {

    private var _controller as AppController;

    function initialize() {
        AppBase.initialize();
        _controller = new AppController();
    }

    function onStart(state as Dictionary?) as Void {
        _controller.start();
    }

    function onStop(state as Dictionary?) as Void {
        _controller.stop();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new InnerPeaceView(), new InnerPeaceDelegate()];
    }
}

function getApp() as InnerPeaceApp {
    return Application.getApp() as InnerPeaceApp;
}
