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
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var font = Graphics.FONT_SMALL;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 25;

        var lines = wrapText(dc, _message, font, width - margin * 2);

        var lineHeight = dc.getFontHeight(font) + 4;
        var totalHeight = lines.size() * lineHeight;
        var startY = (height - totalHeight) / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(
                width / 2,
                startY + i * lineHeight,
                font,
                lines[i] as String,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    private function wrapText(
        dc as Dc,
        text as Lang.String,
        font as Graphics.FontDefinition,
        maxWidth as Lang.Number
    ) as Lang.Array<Lang.String> {
        var words = text.split(" ");
        var lines = [] as Array<String>;
        var current = "";

        for (var i = 0; i < words.size(); i++) {
            var word = words[i] as String;
            var candidate = (current.length() > 0) ? (current + " " + word) : word;
            var dims = dc.getTextDimensions(candidate, font);
            if ((dims[0] as Number) > maxWidth && current.length() > 0) {
                lines.add(current);
                current = word;
            } else {
                current = candidate;
            }
        }

        if (current.length() > 0) {
            lines.add(current);
        }

        return lines;
    }
}
