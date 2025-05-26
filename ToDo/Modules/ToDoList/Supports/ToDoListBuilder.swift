import UIKit
import CoreData

final class ToDoListBuilder {
    static func build(context: NSManagedObjectContext) -> UIViewController {
        let coreDataService = CoreDataService(context: context)
        let service = ToDoListService(coreDataService: coreDataService)
        let interactor = ToDoListInteractor(service: service)
        let view = ToDoListViewController()
        let router = ToDoListRouter(context: context)
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.bottomBar.presenter = presenter
        interactor.output = presenter
        
        return UINavigationController(rootViewController: view)
    }
}
