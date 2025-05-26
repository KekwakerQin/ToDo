import UIKit

extension UILabel {
    // Для большого текста
    static func title(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
        label.textColor = UIColor(named: "TextColor")
        
        return label
    }
    
    // Основное содержание
    static func body(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        label.textColor = UIColor(named: "TextColor")

        return label
    }
    
    // Маленький текст
    static func low(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.low.rawValue, weight: .regular)
        label.textColor = UIColor(named: "TextColor")

        return label
    }
}

