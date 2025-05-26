import UIKit

protocol ToDoListPresenterProtocol {
    func viewDidLoad()
    func didSelectTask(at index: Int)
    func didTapCreateButton()
    func didSelectTaskForEditing(_ task: Task)
    
    func createTask(_ task: Task)
    func deleteTask(with index: String)
    func updateTask(_ task: Task)
    func searchTasks(with query: String)
}

final class ToDoListPresenter: ToDoListPresenterProtocol {
    private var tasks: [Task] = []

    weak var view: ToDoListViewControllerProtocol?
    var interactor: ToDoListInteractorInputProtocol
    var router: ToDoListRouterProtocol
    
    init(view: ToDoListViewControllerProtocol,
         interactor: ToDoListInteractorInputProtocol,
         router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.loadTasks()
    }
    
    func didSelectTask(at index: Int) {
        tasks[index].completed.toggle()
        interactor.updateTask(tasks[index])
        view?.reloadRow(at: index) // кастомный метод, если нужно только строку
    }
    
    func createTask(_ task: Task) {
        interactor.createTask(task)
    }
    
    func deleteTask(with id: String) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
            view?.showTasks(tasks)
        }
        
        interactor.deleteTask(with: id)
    }
    
    func updateTask(_ task: Task) {
        interactor.updateTask(task)
    }
    
    func searchTasks(with query: String) {
        interactor.searchTasks(by: query)
    }
    
    func didTapCreateButton() {
        router.openCreateTask(from: view!)
    }

    func didSelectTaskForEditing(_ task: Task) {
        router.openEditTask(task, from: view!)
    }

}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    func didLoadTasks(_ tasks: [Task]?) {
        self.tasks = tasks ?? []
            view?.showTasks(self.tasks)
    }
    
    func didFailLoadingTasks(_ error: any Error) {
        print("Error: \(error.localizedDescription)")
    }
}
