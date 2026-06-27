import Toybox.Lang;
import Toybox.WatchUi;

class PromptPresenter {

    private var _isShowing as Lang.Boolean;

    function initialize() {
        _isShowing = false;
    }

    // Pushes the prompt view. No-ops if a prompt is already on screen.
    function show(message as Lang.String) as Void {
        if (_isShowing) {
            return;
        }
        _isShowing = true;
        WatchUi.pushView(
            new PromptView(message),
            new PromptDelegate(method(:onDismissed)),
            WatchUi.SLIDE_UP
        );
    }

    function onDismissed() as Void {
        _isShowing = false;
    }
}
