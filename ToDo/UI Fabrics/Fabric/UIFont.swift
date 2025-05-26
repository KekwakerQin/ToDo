import UIKit
extension UIFont {
    static func titleFont() -> UIFont {
        var font = UIFont()
        font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
        return font
    }
    
    static func bodyFont() -> UIFont {
        var font = UIFont()
        font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        return font
    }

    static func lowFont() -> UIFont {
        var font = UIFont()
        font = UIFont.systemFont(ofSize: FontSize.low.rawValue, weight: .regular)
        return font
    }
}
