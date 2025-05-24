import UIKit

protocol ToDoListInteractorInputProtocol {
    func loadTask()
    func toggleTask(at index: Int)
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadTask(_ tasks: [Task]?)
    func didFailLoadingTasks(_ error: Error)
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol {
    weak var output: ToDoListInteractorOutputProtocol?
    let service: ToDoListServiceProtocol
    private var tasks: [Task]? = []
    
    init(service: ToDoListServiceProtocol) {
        self.service = service
    }
    
    func loadTask() {
        self.tasks = service.getTasksFromJSON()
        output?.didLoadTask(tasks)
    }
    
    func toggleTask(at index: Int) {
        tasks?[index].completed.toggle()
        output?.didLoadTask(tasks)
    }
}
