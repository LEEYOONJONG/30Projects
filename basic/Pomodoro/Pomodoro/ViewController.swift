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
    var timerStatus:TimerStatus = .end // default값
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    @IBAction func tapCancelButton(_ sender: Any) {
        switch self.timerStatus{
        case .start, .pause: // 종료 상태로
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisible(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
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
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false// 시작
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // '일시정지'로
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
}
