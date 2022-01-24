import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false // 처음엔 비활성화
        
        // 전달한 텍스트 값을 받으려면 텍스트필드의 텍스트값을 가져와야함 <- delegate 설정 필요.
        emailTextField.delegate = self // 이렇게 해야 해당 델리게이트의 메소드를 사용 가능.
        passwordTextField.delegate = self // passwordTextField의 뒷바라지는 내가 하겠다.
        // EnterEmailVC는 passwordTF에 이벤트가 발생하면 프로토콜에 따라 passwordTF에 응답을 주겠다!
        
        //처음 화면 켰을 때 이메일 입력하기 쉽게 바로 커서가 거기로 위치
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        print("pw type : ", type(of: password))
        // 신규 사용자 생성
        // 순환참조 방지를 위해 weak self
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            print("넘어온 email : \(email), pw : \(password)")
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007://이미 가입한 계정일때
                    //로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
            
        }
    }
    private func showMainViewController(){
        // storyboard에 우리가 만들어 놓은 애를 연결하기 위해
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    private func loginUser(withEmail email:String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]_, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
}

extension EnterEmailViewController:UITextFieldDelegate {
    // email. pw 누르고 리턴 눌렀을 때 키보드가 내려가도록
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // 사용자가 키보드의 return을 눌렀을 때 호출
        view.endEditing(true) // 에디팅 끝나면
//        textField.resignFirstResponder() // 이것도 위와 같은 기능
        
        return false // 내려줘라
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
