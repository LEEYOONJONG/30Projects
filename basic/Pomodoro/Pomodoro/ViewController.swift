import UIKit

enum TimerStatus{
    case start
    case pause
    case end
}
class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    var duration = 60
    var currentSeconds = 0
    var timer: DispatchSourceTimer?
    var timerStatus:TimerStatus = .end // default값
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    @IBAction func tapCancelButton(_ sender: Any) {
        switch self.timerStatus{
        case .start, .pause: // 종료 상태로
            
            self.stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: Any) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus{
        case .end:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // '일시정지'으로
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.cancelButton.isEnabled = true
            self.currentSeconds = self.duration
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false// 시작
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // '일시정지'로
            self.timer?.resume()
        }
    }
    func setTimerInfoViewVisible(isHidden: Bool){
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    func configureToggleButton(){
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    func startTimer(){
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                self?.currentSeconds -= 1
                debugPrint(self?.currentSeconds)
                if self?.currentSeconds ?? 0 <= 0 {
                    self?.stopTimer()
                }
                
            })
            self.timer?.resume()
        }
    }
    func stopTimer(){
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        self.setTimerInfoViewVisible(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        
        self.timer?.cancel()
        self.timer = nil
    }
}
