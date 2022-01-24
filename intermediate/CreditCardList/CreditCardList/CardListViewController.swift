//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by YOONJONG on 2021/10/06.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController{
    // UIViewController + uitableview와 뭐가 다르냐?
    // 동일. but,
    // uitableviewcontroller :  uitableview를 구성하는데 필요한 delegate, datasource가 기본 연결되어 있어 별도 선언 필요 없다. root로 uitableview로 가지게 됨.
    // uiviewcontroller : view를 rootview로 가짐
    var ref: DatabaseReference! // firebasee realtime database -> 우리가 만든 파베 레퍼런스
    var creditCardList:[CreditCard] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        ref = Database.database().reference() // firebase가 우리의 db를 잡아내고, 파베에서 만든 데이터들을 주고받을 수 있음
        ref.observe(.value) { snapshot in // 값을 snapshot이라는 객체로 전달함.
            guard let value = snapshot.value as? [String: [String : Any]] else { return } // 이렇게 타입을 지정하지 않으면 데이터베이스는 스냅샷에서 전달받는 값을 이해하지 못해 항상 닐을 방출.
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value) // json 받기. snapshot 통해 가져온 value
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted { $0.rank < $1.rank}
                DispatchQueue.main.async { // UI를 표현하기에 메인 스레드로.
                    self.tableView.reloadData()
                }
            } catch let error{
                print("ERROR JSON parsing \(error.localizedDescription)")
            }
        }
    }
    
    // 단일 섹션 가질거임. 카드 배열의 인덱스 수가 row수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
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
        
        // option1 : 선택되었는지 쓰기 위해
        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true) // isSelected가 실시간으로 업데이트
        
        
        // option2 : 검색하여 쓰기 위해
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value){[weak self] snapshot in // cardID와 같은 객체를 가져오라고 명령
            guard let self = self,
                    let value = snapshot.value as? [String:[String:Any]],
                  let key = value.keys.first else { return }
            self.ref.child("\(key)/isSelected").setValue(true)
        }
        // 삭제
//        ref.child("Item\(cardID)/isSelected").setValue(nil) //로도 가능
        
    }
    
    // swipe하여 삭제 하기 위해
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // option 1
            let cardID = creditCardList[indexPath.row].id
//            ref.child("Item\(cardID)").removeValue()
            print("삭제 직전")
            for i in creditCardList{
                print("===>      \(i.id), \(i.rank)")
            }
            // option 2
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
                guard let self = self, let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first else { return }
                print("-->", value.keys)
                self.ref.child(key).removeValue()
            }
            print("삭제 직후")
            for i in creditCardList{
                print("===>      \(i.id), \(i.rank)")
            }
        }
    }
}
