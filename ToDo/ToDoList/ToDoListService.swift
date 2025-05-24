import Foundation
protocol ToDoListServiceProtocol {
    func getTasksFromJSON() -> [Task]?
    func setTasksToJSON()
}

final class ToDoListService: ToDoListServiceProtocol {
    func getTasksFromJSON() -> [Task]? {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
            print("File isnt exist todos.json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let taskList = try decoder.decode(TaskList.self, from: data)
            return taskList.todos
        } catch {
            print("Decode error")
            return nil
        }
    }
    
    func setTasksToJSON() {
        //
    }
}
