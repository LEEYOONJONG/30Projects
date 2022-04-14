import SnapKit
import UIKit

final class FeatureSectionCollectionViewCell:UICollectionViewCell{
    private lazy var typeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12, weight:.semibold)
        return label
    }()

    private lazy var appNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight:.bold)
        return label
    }()

    private lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight:.semibold)
        return label
    }()

    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    func setup(){
        setupLayout()
        typeLabel.text = "타입라벨"
        appNameLabel.text = "앱이름라벨"
        descriptionLabel.text = "설명입니다"
        imageView.backgroundColor = .lightGray
    }
}
private extension FeatureSectionCollectionViewCell{
    func setupLayout(){
        [typeLabel, appNameLabel, descriptionLabel, imageView].forEach { addSubview($0) }
        typeLabel.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
        }
        appNameLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(typeLabel.snp.bottom)
        }
        descriptionLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(appNameLabel.snp.bottom).offset(4.0)
        }
        imageView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview().inset(8.0)
        }
                
    }
}