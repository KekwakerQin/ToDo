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


