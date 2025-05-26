import UIKit
import CoreData

protocol CreateTaskRouterProtocol {
    static func createModule(mode: CreateTaskMode, context: NSManagedObjectContext) -> UIViewController
}

final class CreateTaskRouter: CreateTaskRouterProtocol {
    static func createModule(mode: CreateTaskMode, context: NSManagedObjectContext) -> UIViewController {
        let view = CreateTaskViewController()
        let coreDataService = CoreDataService(context: context)
        let service = ToDoListService(coreDataService: coreDataService)
        let interactor = CreateTaskInteractor(service: service)
        let presenter = CreateTaskPresenter(view: view, interactor: interactor)
        
        view.presenter = presenter
        view.mode = mode
        
        return view
    }
}
