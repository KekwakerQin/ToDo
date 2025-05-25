import UIKit

enum FontSize: CGFloat {
    case title = 34
    case body = 16
    case low = 12
}

extension UILabel {
    static func title(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
        label.textColor = UIColor(named: "TextColor")
        
        return label
    }
    
    static func body(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        label.textColor = UIColor(named: "TextColor")

        return label
    }
    
    static func low(_ text: String?) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: FontSize.low.rawValue, weight: .regular)
        label.textColor = UIColor(named: "TextColor")

        return label
    }
}
