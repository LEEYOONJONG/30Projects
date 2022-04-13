import SnapKit
import UIKit

final class TodayCollectionViewCell:UICollectionViewCell{
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    private lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    private lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    func setup(){
        setupSubViews()
        subTitleLabel.text = "서브타이틀입니다"
        titleLabel.text = "타이틀입니다"
        descriptionLabel.text = "설명이지롱"
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
    }
}

private extension TodayCollectionViewCell{
    func setupSubViews(){
        [imageView, titleLabel, subTitleLabel, descriptionLabel]
            .forEach{
                addSubview($0)
            }
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(subTitleLabel)
            $0.trailing.equalTo(subTitleLabel)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(4)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
