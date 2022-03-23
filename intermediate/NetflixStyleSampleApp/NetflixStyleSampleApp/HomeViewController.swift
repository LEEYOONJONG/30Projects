//
//  HomeViewController.swift
//  NetflixStyleSampleApp
//
//  Created by YOONJONG on 2022/03/22.
//

import UIKit

class HomeViewController: UICollectionViewController {
    var contents:[Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "netflix_icon"), style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        contents = getContents()
    }
    
    func getContents() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from:data) else { return [] }
        return list
    }
}
extension HomeViewController {

}
