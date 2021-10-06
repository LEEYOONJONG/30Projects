//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by YOONJONG on 2021/10/06.
//

import UIKit
import Kingfisher

class CardListViewController: UITableViewController{
    // UIViewController + uitableview와 뭐가 다르냐?
    // 동일. but,
    // uitableviewcontroller :  uitableview를 구성하는데 필요한 delegate, datasource가 기본 연결되어 있어 별도 선언 필요 없다. root로 uitableview로 가지게 됨.
    // uiviewcontroller : view를 rootview로 가짐
    
    var creditCardList:[CreditCard] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
    }
    
    // 단일 섹션 가질거임. 카드 배열의 인덱스 수가 row수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        // 이미지 전달을 위해 오픈소스를 사용해야 함. URL만 전달받아 이미지로.
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL) // string to url
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    // cell 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender:nil)
    }
}
