import Foundation

struct TaskList: Decodable {
    let todos: [Task]
//    let counts: String
}

struct Task: Decodable {
    let id: String
    let title: String
    let todo: String?
    var completed: Bool
    let date: String
}

extension Task {
    init(entity: TaskEntity) {
        self.id = entity.id!
        self.title = entity.title ?? ""
        self.todo = entity.todo ?? ""
        self.completed = entity.completed
        self.date = entity.date ?? ""
    }
}

// Эквитабл для сортировки по индексу 
extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.todo == rhs.todo &&
        lhs.completed == rhs.completed &&
        lhs.date == rhs.date
    }
}

extension TaskEntity {
    func update(with task: Task) {
        self.id = task.id
        self.title = task.title
        self.todo = task.todo
        self.completed = task.completed
        self.date = task.date
    }
}

