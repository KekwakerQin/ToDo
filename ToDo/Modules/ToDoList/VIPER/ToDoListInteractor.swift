import UIKit

protocol ToDoListInteractorInputProtocol {
    func loadTasks()
    func toggleTask(at index: Int)
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadTasks(_ tasks: [Task]?)
    func didFailLoadingTasks(_ error: Error)
}

final class ToDoListInteractor: ToDoListInteractorInputProtocol {
    weak var output: ToDoListInteractorOutputProtocol?
    let service: ToDoListServiceProtocol
    private var tasks: [Task] = []
    
    init(service: ToDoListServiceProtocol) {
        self.service = service
    }
    
    func loadTasks() {
        DispatchQueue.global(qos: .background).async {
            let result = self.service.loadTasks()
            DispatchQueue.main.async {
                self.tasks = result
                self.output?.didLoadTasks(self.tasks)
            }
        }
    }
    
    
    func toggleTask(at index: Int) {
        tasks[index].completed.toggle()
        output?.didLoadTasks(tasks)
    }
}
