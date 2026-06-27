import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PromptView extends WatchUi.View {

    private var _message as Lang.String;

    function initialize(message as Lang.String) {
        View.initialize();
        _message = message;
    }

    function onLayout(dc as Dc) as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        // Black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Red radial glow behind heart (layered circles, darkest outward)
        var glowCy = h / 4;
        dc.setColor(0x1A0000, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, glowCy, 90);
        dc.setColor(0x330000, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, glowCy, 68);
        dc.setColor(0x660000, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, glowCy, 48);
        dc.setColor(0x990000, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, glowCy, 28);

        // Heart icon
        _drawHeart(dc, cx, glowCy, 20);

        // Word-wrapped message — FONT_LARGE, ~16 chars per line on 320 px screen
        var font = Graphics.FONT_LARGE;
        var lines = _wrapText(_message, 16);
        var lineH = dc.getFontHeight(font) + 6;
        var totalH = lines.size() * lineH;
        var textY = h / 2 - totalH / 2;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(cx, textY + i * lineH, font, lines[i] as String, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Curved arc above the dots (wide arc, center point below screen)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawArc(cx, h + 55, 130, Graphics.ARC_CLOCKWISE, 210, 330);
        dc.setPenWidth(1);

        // Three pagination dots
        var dotY = h * 7 / 8;
        var dotR = 4;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx - 18, dotY, dotR);
        dc.fillCircle(cx,      dotY, dotR);
        dc.fillCircle(cx + 18, dotY, dotR);
    }

    // Draws a filled red heart centred at (cx, cy) with the given size.
    private function _drawHeart(dc as Dc, cx as Lang.Number, cy as Lang.Number, size as Lang.Number) as Void {
        dc.setColor(0xFF2244, Graphics.COLOR_TRANSPARENT);
        var r = size / 2;
        // Two circles form the top bumps
        dc.fillCircle(cx - r, cy - r / 2, r);
        dc.fillCircle(cx + r, cy - r / 2, r);
        // Triangle fills the lower V
        var pts = [
            [cx - size, cy - r / 2],
            [cx + size, cy - r / 2],
            [cx,        cy + size]
        ];
        dc.fillPolygon(pts);
    }

    // Word-wrap using only substring() — avoids String.split() unavailable on device.
    private function _wrapText(text as Lang.String, maxChars as Lang.Number) as Lang.Array<Lang.String> {
        var lines = [] as Array<String>;
        var len = text.length();
        var pos = 0;

        while (pos < len) {
            if (len - pos <= maxChars) {
                lines.add(text.substring(pos, len) as String);
                break;
            }

            // Scan backwards from pos+maxChars for a space to break on
            var breakAt = pos + maxChars;
            var found = false;
            for (var i = breakAt; i > pos; i--) {
                if (text.substring(i, i + 1).equals(" ")) {
                    lines.add(text.substring(pos, i) as String);
                    pos = i + 1;
                    found = true;
                    break;
                }
            }

            if (!found) {
                lines.add(text.substring(pos, breakAt) as String);
                pos = breakAt;
            }
        }

        return lines;
    }
}
