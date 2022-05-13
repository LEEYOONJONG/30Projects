import UIKit

extension UIButton{
    func setImage(systemName: String){
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
}
