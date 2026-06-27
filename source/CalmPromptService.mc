import Toybox.Lang;

class CalmPromptService {
    private var _prompts as Array<String> = [
        "Breathe: in 4, hold 4, out 4",
        "Name 5 things you can see",
        "Relax your shoulders now",
        "You are safe. This will pass.",
        "Slow breath through your nose"
    ] as Array<String>;

    private var _index as Number = 0;

    function nextPrompt() as String {
        var prompt = _prompts[_index] as String;
        _index = (_index + 1) % _prompts.size();
        return prompt;
    }
}
