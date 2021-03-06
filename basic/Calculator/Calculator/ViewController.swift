//
//  ViewController.swift
//  Calculator
//
//  Created by YOONJONG on 2022/01/06.
//

import UIKit
enum Operation {
    case Add
    case Subtract
    case Multiply
    case Divide
    case unknown
}
class ViewController: UIViewController {
    var displayNumber = ""
    var firstOperand = ""
    var secondOperand = ""
    var result = ""
    var currentOperation:Operation = .unknown
    
    
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   
    @IBAction func tapNumberButton(_ sender: UIButton) {
        
        guard let numberValue = sender.titleLabel?.text else { return }
        print(numberValue)
        
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
        
    }
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains("."){
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    @IBAction func tapMultiplyButton(_ sender: Any) {
        self.operation(.Multiply)
    }
    @IBAction func tapSubtractButton(_ sender: Any) {
        self.operation(.Subtract)
    }
    @IBAction func tapAddButton(_ sender: Any) {
        self.operation(.Add)
    }
    @IBAction func tapEqualButton(_ sender: Any) {
        self.operation(self.currentOperation)
    }
    
    
    func operation(_ operation: Operation){
        if self.currentOperation != .unknown { // ??????????????? ???????????? ?????????
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                print("first : \(firstOperand), second: \(secondOperand)")
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            self.currentOperation = .unknown
            if (self.currentOperation == .unknown) {
                self.secondOperand = ""
                self.result = ""
                self.displayNumber = self.firstOperand
            }
        }
        else { // ?????? ????????? ?????? ???????????????
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
}

