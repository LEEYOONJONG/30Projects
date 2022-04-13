import SnapKit
import UIKit

final class AppViewController:UIViewController{
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        let featureSectionView = UIView()
        let rankingFeatureSectionView = UIView()
        let exchangeCodeButtonView = UIView()
        
        // 색상을 알아보기 쉽게 지정
        featureSectionView.backgroundColor = .red
        rankingFeatureSectionView.backgroundColor = .blue
        exchangeCodeButtonView.backgroundColor = .yellow

        [featureSectionView, rankingFeatureSectionView, exchangeCodeButtonView].forEach{
            $0.snp.makeConstraints{
                $0.height.equalTo(500) // 임의로
            }
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
    }
}
private extension AppViewController{
    func setupNavigationController(){
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
