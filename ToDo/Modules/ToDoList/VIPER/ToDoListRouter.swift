import UIKit
import CoreData

protocol ToDoListRouterProtocol {
    func openCreateTask(from view: ToDoListViewControllerProtocol)
    func openEditTask(_ task: Task, from view: ToDoListViewControllerProtocol)
}

final class ToDoListRouter: ToDoListRouterProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func openCreateTask(from view: ToDoListViewControllerProtocol) {
        let createVC = CreateTaskRouter.createModule(mode: .create, context: context)
        if let sourceVC = view as? UIViewController {
            sourceVC.navigationController?.pushViewController(createVC, animated: true)
        }
    }

    func openEditTask(_ task: Task, from view: ToDoListViewControllerProtocol) {
        let editVC = CreateTaskRouter.createModule(mode: .edit(task: task), context: context)
        if let sourceVC = view as? UIViewController {
            sourceVC.navigationController?.pushViewController(editVC, animated: true)
        }
    }
}
