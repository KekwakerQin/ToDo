import XCTest
@testable import ToDo

final class MockView: ToDoListViewControllerProtocol {
    var shownTasks: [Task]?
    var reloadRowIndex: Int?

    func showTasks(_ tasks: [Task]?) {
        shownTasks = tasks
    }

    func reloadRow(at index: Int) {
        reloadRowIndex = index
    }
}

final class MockInteractor: ToDoListInteractorInputProtocol {
    var loadTasksCalled = false
    var createTaskCalled: Task?
    var deleteTaskCalled: String?
    var updateTaskCalled: Task?

    func loadTasks() { loadTasksCalled = true }
    func createTask(_ task: Task) { createTaskCalled = task }
    func deleteTask(with id: String) { deleteTaskCalled = id }
    func updateTask(_ task: Task) { updateTaskCalled = task }
    func toggleTask(at index: Int) {}
    func searchTasks(by query: String) {}
}

final class MockRouter: ToDoListRouterProtocol {
    var didOpenCreate = false
    var didOpenEdit: Task?

    func openCreateTask(from: ToDoListViewControllerProtocol) {
        didOpenCreate = true
    }

    func openEditTask(_ task: Task, from: ToDoListViewControllerProtocol) {
        didOpenEdit = task
    }
}

final class ToDoListPresenterTests: XCTestCase {
    var presenter: ToDoListPresenter!
    var mockView: MockView!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!

    override func setUp() {
        super.setUp()
        mockView = MockView()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()

        presenter = ToDoListPresenter(view: mockView as! ToDoListViewControllerProtocol, interactor: mockInteractor, router: mockRouter)
    }
    
    // MARK: - Проверка, что при включении приложения Presenter отправляет запрос на подгрузку задач

    func test_viewDidLoad_callsLoadTasks() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.loadTasksCalled, "Presenter должен вызывать interactor.loadTasks()")
    }

    // MARK: - Проверка передачи данных из интерактора в презентер

    func test_didLoadTasks_showsTasksOnView() {
        let tasks = [Task(id: "1", title: "Test", todo: "Body", completed: false, date: "12/03/2025")]
        presenter.didLoadTasks(tasks)
        XCTAssertEqual(mockView.shownTasks?.count, 1)
        XCTAssertEqual(mockView.shownTasks?.first?.title, "Test")
    }

    // MARK: - Создание новой задачи делегируется интерактору

    func test_createTask_callsInteractorCreateTask() {
        let task = Task(id: "123", title: "Create", todo: "", completed: false, date: "14/03/2025")
        presenter.createTask(task)
        XCTAssertEqual(mockInteractor.createTaskCalled?.id, "123")
    }

    // MARK: - Удаление задачи

    func test_deleteTask_callsInteractorDeleteTask() {
        let task = Task(id: "12", title: "Done", todo: "", completed: true, date: "16/03/2025")
        presenter.didLoadTasks([task])
        presenter.deleteTask(with: "12")
        XCTAssertEqual(mockInteractor.deleteTaskCalled, "12")
        XCTAssertEqual(mockView.shownTasks?.count, 0)
    }

    // MARK: - проверка свитча

    func test_didSelectTask_togglesCompletionAndUpdates() {
        let task = Task(id: "1", title: "Toggle", todo: "", completed: false, date: "18/03/2025")
        presenter.didLoadTasks([task])
        presenter.didSelectTask(at: 0)
        XCTAssertEqual(mockInteractor.updateTaskCalled?.id, "1")
        XCTAssertEqual(mockInteractor.updateTaskCalled?.completed, true)
    }
}
