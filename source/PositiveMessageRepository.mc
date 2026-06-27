import Toybox.Lang;
import Toybox.Math;

class PositiveMessageRepository {

    private var _stress as Lang.Array<Lang.String>;
    private var _morning as Lang.Array<Lang.String>;
    private var _midday as Lang.Array<Lang.String>;
    private var _evening as Lang.Array<Lang.String>;

    function initialize() {
        if (TEST_MODE) {
            _stress  = ["[TEST] Stress message 1", "[TEST] Stress message 2"] as Array<String>;
            _morning = ["[TEST] Morning message"] as Array<String>;
            _midday  = ["[TEST] Midday message"] as Array<String>;
            _evening = ["[TEST] Evening message"] as Array<String>;
        } else {
            _stress = [
                "Pause for a moment. Take one slow breath. You're doing well.",
                "You don't need to solve everything right now.",
                "Relax your shoulders. Breathe slowly. One step at a time.",
                "Your mind deserves a short break.",
                "It's okay to pause before continuing."
            ] as Array<String>;

            _morning = [
                "Good morning. Focus on what you can control today.",
                "Start today with one deep breath and one clear intention.",
                "One small step forward is still progress.",
                "Today is a fresh opportunity. Take it gently."
            ] as Array<String>;

            _midday = [
                "Take a minute to stretch and reset your mind.",
                "You have already made progress today. Keep going.",
                "A short pause now sharpens your focus later.",
                "Breathe. You are handling things well."
            ] as Array<String>;

            _evening = [
                "Today's work is enough. Give yourself permission to rest.",
                "Leave today's worries here. Tomorrow is a new opportunity.",
                "You showed up today. That matters.",
                "Rest is part of doing well. Take it."
            ] as Array<String>;
        }
    }

    function getStressMessage() as Lang.String {
        return _pickRandom(_stress);
    }

    function getMorningMessage() as Lang.String {
        return _pickRandom(_morning);
    }

    function getMiddayMessage() as Lang.String {
        return _pickRandom(_midday);
    }

    function getEveningMessage() as Lang.String {
        return _pickRandom(_evening);
    }

    private function _pickRandom(messages as Lang.Array<Lang.String>) as Lang.String {
        var idx = Math.rand() % messages.size();
        return messages[idx] as String;
    }
}
