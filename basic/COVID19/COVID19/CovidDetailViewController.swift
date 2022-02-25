//
//  CovidDetailViewControllerTableViewController.swift
//  COVID19
//
//  Created by YOONJONG on 2022/02/23.
//

import UIKit

class CovidDetailViewController: UITableViewController {
      
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    var covidOverview:CovidOverview?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    func configureView(){
        navigationItem.largeTitleDisplayMode = .always // 이 뷰컨에서만 Large Title 보이게끔
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName // 네비게이션 바 타이틀에 지역 이름 들어가게
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
        self.regionalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
    }
}
