import UIKit

extension UIButton {
    
    // Базовая фабрика чтобы делать быстро кнопки с иконкой из SF Symbols
    static func defaultButton(systemNameImage image: String) -> UIButton {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = .yellow

        return button
    }
}
