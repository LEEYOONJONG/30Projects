//
//  Content.swift
//  NetflixStyleSampleApp
//
//  Created by YOONJONG on 2022/03/23.
//

import Foundation
import UIKit

struct Content:Decodable{
    let sectionType:SectionType
    let sectionName:String
    let contentItem:[Item]
    
    enum SectionType: String, Decodable{
        case basic
        case main
        case large
        case rank
    }
}

struct Item:Decodable{
    let description:String
    let imageName:String
    var image:UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
