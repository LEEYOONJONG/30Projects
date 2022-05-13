import UIKit
import SnapKit

final class UploadViewController: UIViewController{
    private let uploadImage:UIImage
    private let imageView = UIImageView()
    private lazy var textView:UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.text = "입력하세요.."
        textView.textColor = .secondaryLabel
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        imageView.image = uploadImage
        setupNavigationItem()
        setupLayout()
    }
    init(uploadImage: UIImage){
        self.uploadImage = uploadImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension UploadViewController{
    func setupNavigationItem(){
        navigationItem.title = "새 게시글"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapLeftButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "공유", style: .plain, target: self, action: #selector(didTapRightButton))
    }
    @objc func didTapLeftButton(){
        dismiss(animated:  true)
    }
    @objc func didTapRightButton(){
        dismiss(animated:  true)
    }
    func setupLayout(){
        [imageView, textView].forEach { view.addSubview($0) }
        let imageViewInset:CGFloat = 16
        imageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(imageViewInset)
            $0.leading.equalToSuperview().inset(imageViewInset)
            $0.width.equalTo(100)
            $0.height.equalTo(imageView.snp.width)
        }

        textView.snp.makeConstraints{
            $0.leading.equalTo(imageView.snp.trailing).offset(imageViewInset)
            $0.trailing.equalToSuperview().inset(imageViewInset)
            $0.top.equalTo(imageView.snp.top)
            $0.bottom.equalTo(imageView.snp.bottom)
        }
    }
}
extension UploadViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.textColor = .label
        textView.text = nil
    }
}
