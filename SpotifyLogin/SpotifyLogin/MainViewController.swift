//
//  MainViewController.swift
//  SpotifyLogin
//
//  Created by YOONJONG on 2021/09/30.
//

import UIKit
import FirebaseAuth

class MainViewController:UIViewController {
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var welcomeLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        //로그인 했을 경우 파베 인증을 통해 로그인 사용자의 정보 가져오기
        let email = Auth.auth().currentUser?.email ?? "모 고객"
        welcomeLabel.text = """
환영합니다.
\(email)님
"""
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"// email사인인지 아닌지
        resetPasswordButton.isHidden = !isEmailSignIn
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        let email = Auth.auth().currentUser?.email ?? ""
        //비밀번호 재설정 이메일 전송함
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
}
