import Foundation
import CoreData

protocol CreateTaskInteractorProtocol {
    func createTaskFromText(_ lines: [String])
    func update(task: Task, withLines: [String])
    func deleteTask(_ task: Task)
}

final class CreateTaskInteractor: CreateTaskInteractorProtocol {
    let service: ToDoListServiceProtocol
    
    init(service: ToDoListServiceProtocol) {
        self.service = service
    }
    
    func createTaskFromText(_ lines: [String]) {
        DispatchQueue.global(qos: .userInitiated).async {
            let id = self.service.generateNextId()
            let title = lines.first?.isEmpty == false ? lines.first! : "Заголовок #\(id)"
            let todo = lines.dropFirst().joined(separator: "\n")
            
            let task = Task(
                id: "\(id)",
                title: title,
                todo: todo,
                completed: false,
                date: self.currentDate()
            )
            
            self.service.createTask(task)
        }
    }
    
    func update(task: Task, withLines lines: [String]) {
        DispatchQueue.global(qos: .userInitiated).async {
            let title = lines.first ?? ""
            let todo = lines.dropFirst().joined(separator: "\n")
            
            let updated = Task(
                id: task.id,
                title: title,
                todo: todo,
                completed: task.completed,
                date: task.date
            )
            
            self.service.updateTask(updated)
        }
    }
    
    func deleteTask(_ task: Task) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.deleteTask(with: task.id)
        }
    }
    
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: Date())
    }
}
