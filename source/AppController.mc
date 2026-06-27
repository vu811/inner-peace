import Toybox.Lang;

class AppController {

    private var _heartRateMonitor as HeartRateMonitor;
    private var _stressDetector as StressDetector;
    private var _repository as PositiveMessageRepository;
    private var _scheduler as MessageScheduler;
    private var _presenter as PromptPresenter;

    function initialize() {
        _repository = new PositiveMessageRepository();
        _presenter = new PromptPresenter();
        _stressDetector = new StressDetector(method(:onStressDetected));
        _heartRateMonitor = new HeartRateMonitor(method(:onHeartRate));
        _scheduler = new MessageScheduler(method(:onScheduledTime));
    }

    function start() as Void {
        _heartRateMonitor.start();
        _scheduler.start();
    }

    function stop() as Void {
        _heartRateMonitor.stop();
        _scheduler.stop();
    }

    function onHeartRate(bpm as Lang.Number) as Void {
        _stressDetector.evaluate(bpm);
    }

    function onStressDetected() as Void {
        _presenter.show(_repository.getStressMessage());
    }

    // slot: 0 = morning, 1 = midday, 2 = evening
    function onScheduledTime(slot as Lang.Number) as Void {
        var message as Lang.String;
        if (slot == 0) {
            message = _repository.getMorningMessage();
        } else if (slot == 1) {
            message = _repository.getMiddayMessage();
        } else {
            message = _repository.getEveningMessage();
        }
        _presenter.show(message);
    }
}
