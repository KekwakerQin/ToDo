import UIKit

protocol ToDoListRouterProtocol {
    static func createModule() -> UIViewController
}

final class ToDoListRouter: ToDoListRouterProtocol {
    static func createModule() -> UIViewController {
        let service = ToDoListService()
        let interactor = ToDoListInteractor(service: service)
        let view = ToDoListView()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
