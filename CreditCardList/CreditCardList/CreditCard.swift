//
//  CreditCard.swift
//  CreditCardList
//
//  Created by YOONJONG on 2021/10/06.
//

import Foundation

// data 읽을땐 디코딩, 쓸땐 인코딩

struct CreditCard: Codable{
    let id:Int
    let rank:Int
    let name:String
    let cardImageURL:String
    let promotionDetail: PromotionDetail
    let isSelected:Bool? // 추후 카드 선택시 생성
}
struct PromotionDetail: Codable{
    let companyName:String
    let amount:Int
    let period:String
    let benefitDate:String
    let benefitDetail:String
    let benefitCondition:String
    let condition:String
}
