import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class BreathingView extends WatchUi.View {
    private var _prompt as String;

    function initialize(prompt as String) {
        View.initialize();
        _prompt = prompt;
    }

    function onLayout(dc as Dc) as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Accent bar at top
        dc.setColor(0x4488FF, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, w, 4);

        // Title
        dc.setColor(0x4488FF, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 6, Graphics.FONT_SMALL, "Inner Peace", Graphics.TEXT_JUSTIFY_CENTER);

        // Heart icon area — simple heart rate label
        dc.setColor(0xFF4466, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 3, Graphics.FONT_SMALL, "Heart rate elevated", Graphics.TEXT_JUSTIFY_CENTER);

        // Prompt
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 2, Graphics.FONT_MEDIUM, _prompt, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Dismiss hint
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h * 5 / 6, Graphics.FONT_TINY, "Swipe right to dismiss", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
