import Foundation
protocol ToDoListServiceProtocol {
    func loadTasks() -> [Task]
    func getTasksFromJSON() -> [Task]
    func toggleTask(at index: Int)
    func setTasksToJSON()
}

final class ToDoListService: ToDoListServiceProtocol {
    private let coreDataService: CoreDataService

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }

    func loadTasks() -> [Task] {
        coreDataService.clearAllTasks()
        if coreDataService.isEmpty() {
            let json = getTasksFromJSON()
            coreDataService.saveTasks(json)
            print("Подтянуто с джсон")
        }
        return coreDataService.fetchTasks()
    }
    
    func getTasksFromJSON() -> [Task] {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
            print("File isnt exist todos.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let taskList = try decoder.decode(TaskList.self, from: data)
            return taskList.todos
        } catch {
            print("Decode error")
            return []
        }
    }
    
    func toggleTask(at index: Int) {
        coreDataService.toggleTask(at: index)
    }
    
    func setTasksToJSON() {
        //
    }
}
