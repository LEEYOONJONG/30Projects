import UIKit

class EnterEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false // 처음엔 비활성화
        
        // 전달한 텍스트 값을 받으려면 텍스트필드의 텍스트값을 가져와야함 <- delegate 설정 필요
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //처음 화면 켰을 때 이메일 입력하기 쉽게 바로 커서가 거기로 위치
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = .white
//        navigationController?.navigationBar.barTintColor = .white
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
}

extension EnterEmailViewController:UITextFieldDelegate {
    // email. pw 누르고 리턴 눌렀을 때 키보드가 내려가도록
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true) // 에디팅 끝나면
        return false // 내려줘라
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
