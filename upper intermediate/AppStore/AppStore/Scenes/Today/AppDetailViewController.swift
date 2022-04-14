import SnapKit
import UIKit
import Kingfisher

final class AppDetailViewController:UIViewController{
    private let today:Today
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // 이미지뷰의 프레임보다 큰 이미지가 위치했을 때 이미지가 넘치지 않게
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()

    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label // 다크모드에서 대응 가능
        return label
    }()
    
    private let subTitleLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let downloadButton:UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        appIconImageView.backgroundColor = .lightGray
        titleLabel.text = today.title
        subTitleLabel.text = today.subTitle
        if let imageURL = URL(string: today.imageURL){ // 내가 추가
            appIconImageView.kf.setImage(with: imageURL)
        }
    }
    init(today: Today){
        self.today = today
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: Private
private extension AppDetailViewController{
    func setupViews(){
        [appIconImageView, titleLabel, subTitleLabel, downloadButton, shareButton]
            .forEach{ view.addSubview($0) }
        
        // 서브뷰들의 오토레이아웃 설정해주겠다.
        appIconImageView.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(16)
            $0.height.equalTo(100)
            $0.width.equalTo(appIconImageView.snp.height)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(appIconImageView.snp.top)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        subTitleLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        downloadButton.snp.makeConstraints{
            $0.bottom.equalTo(appIconImageView.snp.bottom)
            $0.height.equalTo(24)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(60)
        }
        shareButton.snp.makeConstraints{
            $0.bottom.equalTo(appIconImageView.snp.bottom)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
