import UIKit
import SnapKit

final class StationDetailCollectionViewCell:UICollectionViewCell{
    private lazy var lineLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    private lazy var remainTimeLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    func setup(){
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        backgroundColor = .systemBackground
        
        [lineLabel, remainTimeLabel].forEach{ addSubview($0) }
        lineLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(16)
        }
        remainTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(lineLabel)
            $0.top.equalTo(lineLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        //라벨이 잘 추가되었나
        lineLabel.text = "죽전 방면"
        remainTimeLabel.text = "서울숲 도착"
    }
}
