import SnapKit
import UIKit

final class FeatureSectionView:UIView{
    private var featureList:[Feature] = []
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FeatureSectionCollectionViewCell.self, forCellWithReuseIdentifier: "FeatureSectionCollectionViewCell")
        return collectionView
    }()
    
    private let separatorView = Separator(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        fetchData()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FeatureSectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        featureList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureSectionCollectionViewCell", for: indexPath) as? FeatureSectionCollectionViewCell
        cell?.setup(feature: featureList[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
}
extension FeatureSectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}
private extension FeatureSectionView{
    func setupViews(){
        [collectionView, separatorView].forEach { addSubview($0) }
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(snp.width)
            $0.bottom.equalToSuperview()
        }
        separatorView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
    }
    func fetchData(){
        guard let url = Bundle.main.url(forResource: "Feature", withExtension: "plist") else { return }
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([Feature].self, from: data)
            featureList = result
        } catch {}
    }
}
