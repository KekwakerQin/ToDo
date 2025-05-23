import UIKit
import SwiftUI // Для обертки канвас

class RecentrlyDeletedView: UIViewController {
    
    // MARK: - Components

    // MARK: - Views Actions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
    
    }
    
    // MARK: - Setups
    
    // MARK: - Constraints

    // MARK: - Actions
    
}

// MARK: - Extensions


// MARK: - SwiftUI Canvas Wrapper
struct RecentrlyDeletedViewWrapper: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = RecentrlyDeletedView
    
    func makeUIViewController(context: Context) -> RecentrlyDeletedView {
            return RecentrlyDeletedView()
    }
    
    func updateUIViewController(_ uiViewController: RecentrlyDeletedView, context: Context) {
        // nothing do
    }
}

#Preview {
    RecentrlyDeletedViewWrapper()
}
