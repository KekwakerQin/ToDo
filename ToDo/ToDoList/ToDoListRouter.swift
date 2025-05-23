import UIKit

final class ToDoListRouter {
    static func createModule() -> UIViewController {
        let view = ToDoListView()
        return UINavigationController(rootViewController: view)
    }
}
