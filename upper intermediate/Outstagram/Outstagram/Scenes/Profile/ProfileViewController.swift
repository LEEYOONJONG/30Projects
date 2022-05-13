import UIKit

class ProfileViewController:UIViewController{
    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        
        return imageView
    }()
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "이윤종"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "하요"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // 팔로우, 메세지 버튼
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.white, for:.normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 3
        return button
    }()
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지", for: .normal)
        button.setTitleColor(.black, for:.normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray2
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private let photoDataView = ProfileDataView(title: "게시물", count: 99)
    private let followerDataView = ProfileDataView(title: "팔로워", count: 999)
    private let followingDataView = ProfileDataView(title: "팔로잉", count: 19)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
}
extension ProfileViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
        
        cell?.setup(with: UIImage())
        return cell ?? UICollectionViewCell()
    }
}
extension ProfileViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = (collectionView.frame.width - 1)/3
        return CGSize(width: width, height: width)
    }
}
private extension ProfileViewController{
    func setupNavigationBar(){
        navigationItem.title = "Yoonjong"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapRightBarButtonItem))
        navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    @objc func didTapRightBarButtonItem(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        [
            UIAlertAction(title: "회원 정보 변경", style: .default, handler: nil),
            UIAlertAction(title: "탈퇴하기", style: .destructive, handler: nil),
            UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        ].forEach{ actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
    func setupLayout(){
        let buttonStackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        buttonStackView.spacing = 4
        buttonStackView.distribution = .fillEqually
        let dataStackView = UIStackView(arrangedSubviews: [photoDataView, followerDataView, followingDataView])
        dataStackView.spacing = 4
        dataStackView.distribution = .fillEqually

        [
            profileImageView, dataStackView, nameLabel, descriptionLabel, buttonStackView, collectionView
        ].forEach { view.addSubview($0) }
        
        let inset:CGFloat = 16 // 인셋 많이 사용되므로
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(inset)
            $0.leading.equalToSuperview().inset(inset)
            $0.width.equalTo(80)
            $0.height.equalTo(profileImageView.snp.width)
        }
        dataStackView.snp.makeConstraints{
            $0.leading.equalTo(profileImageView.snp.trailing).offset(inset)
            $0.trailing.equalToSuperview().inset(inset)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12.0)
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.trailing.equalToSuperview().inset(inset)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.0)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(buttonStackView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
    }
}
