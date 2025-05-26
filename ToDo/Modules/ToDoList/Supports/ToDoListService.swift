import Foundation
protocol ToDoListServiceProtocol {
    func loadTasks() -> [Task]
    func getTasksFromJSON() -> [Task]
    func toggleTask(at index: Int)
    func generateNextId() -> String
    
    func updateTask(_ task: Task)
    func deleteTask(with id: String)
    func createTask(_ task: Task)
    func searchTasksByTitle(_ title: String) -> [Task]
}

final class ToDoListService: ToDoListServiceProtocol {

    let coreDataService: CoreDataService

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }

    func loadTasks() -> [Task] {
        if coreDataService.isEmpty() {
            let json = getTasksFromJSON()
            coreDataService.saveTasks(json)
            print("Подтянуто с джсон")
        }
        return coreDataService.fetchTasks()
    }

    func getTasksFromJSON() -> [Task] {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
            print("Файл todos.json не найден")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let taskList = try decoder.decode(TaskList.self, from: data)
            return taskList.todos
        } catch {
            print("Ошибка декодирования JSON: \(error)")
            return []
        }
    }

    func toggleTask(at index: Int) {
        self.coreDataService.toggleTask(at: index)
        self.coreDataService.saveContext()
    }

    func updateTask(_ task: Task) {
        guard let entity = self.coreDataService.fetchEntity(by: task.id) else { return }

        entity.title = task.title
        entity.todo = task.todo
        entity.completed = task.completed
        entity.date = task.date

        self.coreDataService.saveContext()
    }

    func deleteTask(with id: String) {
        print("service: delete task with id \(id)")
        guard let entity = self.coreDataService.fetchEntity(by: id) else { return }
        self.coreDataService.delete(entity)
        self.coreDataService.saveContext()
    }

    func createTask(_ task: Task) {
        let entity = TaskEntity(context: self.coreDataService.context)
        entity.id = task.id
        entity.title = task.title
        entity.completed = task.completed
        entity.date = task.date
        entity.todo = task.todo

        self.coreDataService.saveContext()
    }

    func searchTasksByTitle(_ title: String) -> [Task] {
        return coreDataService.searchTasksByTitle(title)
    }

    func generateNextId() -> String {
        return coreDataService.generateNextId()
    }
}
