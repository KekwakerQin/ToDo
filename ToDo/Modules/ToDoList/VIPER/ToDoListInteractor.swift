import UIKit
import CoreData

protocol ToDoListInteractorInputProtocol {
    func loadTasks()
    func toggleTask(at index: Int)
    
    func createTask(_ task: Task)
    func deleteTask(with id: String)
    func updateTask(_ task: Task)
    func searchTasks(by query: String)
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadTasks(_ tasks: [Task]?)
    func didFailLoadingTasks(_ error: Error)
}

final class ToDoListInteractor: NSObject, ToDoListInteractorInputProtocol {
    
    weak var output: ToDoListInteractorOutputProtocol?
    let service: ToDoListServiceProtocol
    private var tasks: [Task] = []
    
    private var fetchedResultsController: NSFetchedResultsController<TaskEntity>!

    init(service: ToDoListServiceProtocol) {
        self.service = service
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let context = (service as! ToDoListService).coreDataService.context // cast к конкретной реализации
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            let entities = fetchedResultsController.fetchedObjects ?? []
            tasks = entities.map(Task.init)
        } catch {
            output?.didFailLoadingTasks(error)
        }
    }
    
    // Подгрузить задачи из джсона или кордаты
    func loadTasks() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.loadTasks()
            DispatchQueue.main.async {
                self.output?.didLoadTasks(self.tasks)
            }
        }
    }
    
    // Создать задачу в кор дату
    func createTask(_ task: Task) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.createTask(task)
            DispatchQueue.main.async {
                self.tasks.append(task)
                self.output?.didLoadTasks(self.tasks)
            }
        }
    }
    
    // Удаление
    func deleteTask(with id: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.deleteTask(with: id)
        }
    }
    
    // Серчинг
    func searchTasks(by query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredTasks = self.service.searchTasksByTitle(query)
            DispatchQueue.main.async {
                self.output?.didLoadTasks(filteredTasks)
            }
        }
    }
    
    // Изменение существующей задачи
    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.updateTask(task)
        }
    }
    
    // Переключение "выполнености"
    func toggleTask(at index: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.toggleTask(at: index)
        }
    }
}

extension ToDoListInteractor: NSFetchedResultsControllerDelegate {
    // Наблюдатель
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let entities = controller.fetchedObjects as? [TaskEntity] else { return }
        let updatedTasks = entities.map(Task.init)
        tasks = updatedTasks
        DispatchQueue.main.async {
            self.output?.didLoadTasks(self.tasks)
        }
    }
}
