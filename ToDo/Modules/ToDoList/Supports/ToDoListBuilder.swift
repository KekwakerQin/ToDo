import UIKit
import CoreData

final class ToDoListBuilder {
    static func build(context: NSManagedObjectContext) -> UIViewController {
        let coreDataService = CoreDataService(context: context)
        let service = ToDoListService(coreDataService: coreDataService)
        let interactor = ToDoListInteractor(service: service)
        let view = ToDoListView()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
