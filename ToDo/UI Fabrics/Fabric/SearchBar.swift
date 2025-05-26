import UIKit

extension UISearchBar {
    static func generalWrapper() -> UISearchBar {
        let sb = UISearchBar()
        
        sb.searchBarStyle = .minimal
        sb.barTintColor = UIColor(named: "BackgroundColor") // для внешнего фона
        sb.backgroundColor = UIColor(named: "BackgroundColor") // для заднего фона
        sb.searchTextField.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.9)
        sb.returnKeyType = .search
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search"
        sb.barStyle = .default
        
        return sb
    }
}
