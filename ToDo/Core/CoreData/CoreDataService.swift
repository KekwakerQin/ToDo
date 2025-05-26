import UIKit
import CoreData

// Что стоило бы улучшить: добавить протокола и разделить наверное логику. Сейчас это мешанина из методов, можно разделить на основной функционал в основном классе, а для дебагга вынести в экстеншон
final class CoreDataService {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Проверка на пустоту, если при первом заходе - подгрузить из джсона
    func isEmpty() -> Bool {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        return count == 0
    }
    
    // Для откладки нужна была (вывод данных из кор даты), просто оставлю
    func printAllTasks() {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        do {
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                print("ID: \(task.id ?? "nil"), Title: \(task.title ?? "nil"), Body: \(task.todo ?? "nil")")
            }
        } catch {
            print("Ошибка при fetch: \(error)")
        }
    }
    
    func saveTasks(_ tasks: [Task]) {
        for task in tasks {
            let entity = TaskEntity(context: context)
            entity.id = task.id
            entity.title = task.title
            entity.completed = task.completed
            entity.todo = task.todo
            entity.date = task.date
        }
        try? context.save()
    }
    
    func fetchEntity(by id: String) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    // Принты для откладки тоже понадобились, чтобы посмотреть корректно ли удаление
    func delete(_ entity: TaskEntity) {
        print("DELETE_________")
        context.delete(entity)
        printAllTasks()
        print("_______________")
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения в CoreDataService")
        }
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        guard let entities = try? context.fetch(request) else { return [] }
        
        return entities.map {
            Task(id: $0.id!, title: $0.title ?? "", todo: $0.todo ?? "", completed: $0.completed, date: $0.date ?? "")
        }
    }
    
    func searchTasksByTitle(_ title: String) -> [Task] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        if !title.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        }

        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        do {
            let results = try context.fetch(fetchRequest)
            return results.map { Task(entity: $0) }
        } catch {
            print("Ошибка поиска:", error)
            return []
        }
    }
    
    func toggleTask(at index: Int) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        guard let tasks = try? context.fetch(request), index < tasks.count else { return }
        tasks[index].completed.toggle()
        try? context.save()
    }
    
    func generateNextId() -> String {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            if let last = results.first,
               let lastIdString = last.id,
               let lastId = Int(lastIdString) {
                return String(lastId + 1)
            }
        } catch {
            print("Ошибка генерации id:", error)
        }

        return ""
    }
}
