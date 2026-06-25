import Toybox.Lang;
import Toybox.WatchUi;

class InnerPeaceDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        return true;
    }

    function onBack() as Boolean {
        return false;
    }
}
