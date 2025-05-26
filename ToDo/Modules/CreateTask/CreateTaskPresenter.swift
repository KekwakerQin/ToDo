protocol CreateTaskPresenterProtocol {
    func handleBackWithRawText(_ text: String)
    func handleUpdate(for task: Task, withRawText: String)
    func deleteTask(_ task: Task)
}

final class CreateTaskPresenter: CreateTaskPresenterProtocol {
    weak var view: CreateTaskViewController?
    var interactor: CreateTaskInteractorProtocol

    init(view: CreateTaskViewController? = nil, interactor: CreateTaskInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func handleBackWithRawText(_ text: String) {
        let lines = text.components(separatedBy: .newlines)
        interactor.createTaskFromText(lines)
    }
    
    func handleUpdate(for task: Task, withRawText: String) {
        let lines = withRawText.components(separatedBy: .newlines)
        interactor.update(task: task, withLines: lines)
    }
    
    func deleteTask(_ task: Task) {
        interactor.deleteTask(task)
    }
    
    
}
