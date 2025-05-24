import UIKit

protocol ToDoListPresenterProtocol {
    func viewDidLoad()
    func didSelectTask(at index: Int) 
}

final class ToDoListPresenter: ToDoListPresenterProtocol {
    
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorInputProtocol
    var router: ToDoListRouterProtocol
    
    init(view: ToDoListViewProtocol,
         interactor: ToDoListInteractorInputProtocol,
         router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.loadTask()
    }
    
    func didSelectTask(at index: Int) {
        interactor.toggleTask(at: index)
    }
}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    func didLoadTask(_ tasks: [Task]?) {
        view?.showTasks(tasks)
    }
    
    func didFailLoadingTasks(_ error: any Error) {
        print("Error: \(error.localizedDescription)")
    }
}
