//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by YOONJONG on 2021/11/09.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapCodePushButton(_ sender: UIButton) {
        // optional로 반환하기에 Guard let으로
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else { return }
        viewController.name = "Gunter"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.name = "gunter"
        viewController.delegate = self // 이를 통해 delegate를 위임받게 됨
        self.present(viewController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 전환하려는 VC 인스턴스를 가져오겠다.
        if let viewController = segue.destination as? SeguePushViewController {
            viewController.name = "yeah"
        }
    }
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
}

