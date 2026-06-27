import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class InnerPeaceView extends WatchUi.View {
    private var _heartRate as Number?;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
    }

    function setHeartRate(hr as Number) as Void {
        _heartRate = hr;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Title
        dc.setColor(0x4488FF, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 8, Graphics.FONT_SMALL, "Inner Peace", Graphics.TEXT_JUSTIFY_CENTER);

        // Heart rate number
        var hrText = _heartRate != null ? (_heartRate as Number).toString() : "--";
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h / 3, Graphics.FONT_NUMBER_HOT, hrText, Graphics.TEXT_JUSTIFY_CENTER);

        // bpm label
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w / 2, h * 2 / 3, Graphics.FONT_TINY, "bpm", Graphics.TEXT_JUSTIFY_CENTER);

        // Status row
        if (TEST_MODE) {
            dc.setColor(0xFFAA00, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h * 5 / 6, Graphics.FONT_TINY, "TEST MODE - alert in ~9s", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h * 5 / 6, Graphics.FONT_TINY, "Monitoring...", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
