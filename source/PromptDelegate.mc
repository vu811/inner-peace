import Toybox.Lang;
import Toybox.WatchUi;

class PromptDelegate extends WatchUi.BehaviorDelegate {

    private var _onDismiss as Lang.Method;

    function initialize(onDismiss as Lang.Method) {
        BehaviorDelegate.initialize();
        _onDismiss = onDismiss;
    }

    function onBack() as Lang.Boolean {
        _onDismiss.invoke();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onMenu() as Lang.Boolean {
        return true;
    }
}
