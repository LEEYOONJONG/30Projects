//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by YOONJONG on 2021/11/09.
//

import UIKit

protocol SendDataDelegate:AnyObject {
    func sendData(name:String) // name을 넘길 수 있게
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var name:String?
    weak var delegate:SendDataDelegate? // delegate 변수 앞에는 Weak를 붙여줘야. 안붙으면 강한 순한 촴조가 발생하여 메모리 누수가 발생할 수 있음.
    // delegate 변수 선언을 통해 delegate는 이를 위임할 준비 완료!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        // 데이터 전달받은 뷰컨에서 SendData delegate 프로토콜을 채택하고, delegate를 위임받게 되면 senddata delegate 프로토콜 채택한 이전화면 뷰컨에서 정의된 sendData함수가 실행되게 됨.
        self.delegate?.sendData(name: "NewGunter")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
