import Foundation

struct TaskList: Decodable {
    let todos: [Task]
}

struct Task: Decodable {
    let title: String
    let todo: String?
    var completed: Bool
    let date: String
}

extension Task {
    init(entity: TaskEntity) {
        self.title = entity.title ?? ""
        self.todo = entity.todo ?? ""
        self.completed = entity.completed
        self.date = entity.date ?? ""
    }
}

extension TaskEntity {
    func update(with task: Task) {
        self.title = task.title
        self.todo = task.todo
        self.completed = task.completed
        self.date = task.date
    }
}
