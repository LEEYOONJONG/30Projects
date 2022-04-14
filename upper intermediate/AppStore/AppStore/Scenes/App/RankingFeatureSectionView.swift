import SnapKit
import UIKit

final class RankingFeatureSectionView:UIView{
    

    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.text = "iPhone이 처음이라면"
        return label
    }()

    private lazy var showAllAppsButton:UIButton = {
        let button = UIButton()
        button.setTitle("모두 보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return button
    }()

    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32 //
        layout.minimumInteritemSpacing = 0 //
        layout.sectionInset = UIEdgeInsets(top:0, left:16, bottom:0, right:16) //
        let collectionView = UICollectionView(frame: .zero,    collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(RankingFeatureCollectionViewCell.self, forCellWithReuseIdentifier: "RankingFeatureCollectionViewCell")
        return collectionView
    }()

    private let separatorView = Separator(frame:.zero) // 구분선 추가
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension RankingFeatureSectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: RankingFeatureCollectionViewCell.height)
    }
}
extension RankingFeatureSectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingFeatureCollectionViewCell", for: indexPath) as? RankingFeatureCollectionViewCell
        cell?.setup()
        return cell ?? UICollectionViewCell()
    }
}

private extension RankingFeatureSectionView{
    func setupViews(){
        [titleLabel, showAllAppsButton, collectionView, separatorView].forEach { addSubview($0) }
        titleLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(16)
            $0.trailing.equalTo(showAllAppsButton.snp.leading).offset(8)
        }
        showAllAppsButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(RankingFeatureCollectionViewCell.height*3) // 여기서 *4 하면 셀이 4개가 표시될 수 있다.
            $0.leading.trailing.equalToSuperview()
        }
        separatorView.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
