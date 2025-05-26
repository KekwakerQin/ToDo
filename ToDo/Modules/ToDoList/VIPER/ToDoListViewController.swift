import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task]?)
}

class ToDoListView: UIViewController {
    
    // MARK: - Components
    
    var presenter: ToDoListPresenterProtocol?
    
    private let taskCountLabel = UILabel.low("0 Задач")
    private let searchBar = UISearchBar.generalWrapper()
    var searchTimer: Timer?
    private let label = UILabel.title("Заголовок")
    private let tableView = UITableView.ToDoList()
    private var tasks: [Task] = []
    
    let bottomBar = BottomBarView()
        
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        presenter?.viewDidLoad()

        print("View loaded")
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")

        setupSubviews()
        
        addConstraints()
        
        addDismissKeyBoardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Setups
    
    private func setupSubviews() {
        view.addSubview(label)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
    }
    

    // MARK: - Constraints
    
    private func addConstraints() {
        labelSetupConstraints()
        searchBarSetupConstraints()
        bottomBarSetupContraints()
        tableViewSetupConstraints()
    }
    
    private func labelSetupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
        ])
    }
    
    private func searchBarSetupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func tableViewSetupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
    }
    
    private func bottomBarSetupContraints() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                    bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    bottomBar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        presenter?.didTapCreateButton()
    }
    
    private func makePreviewCell(at indexPath: IndexPath) -> UIViewController? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let previewController = UIViewController()
        previewController.view = cell.snapshotView(afterScreenUpdates: false)
        previewController.preferredContentSize = cell.bounds.size

        return previewController
    }
    
    // MARK: bar manipulate
    
    func updateTaskCount(_ count: Int) {
        bottomBar.setTaskCount(count)
    }
    
    private func addDismissKeyBoardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Search bar triggered: \(searchBar.text ?? "")")
    }
    
}

// MARK: - Extensions


extension ToDoListView: UITableViewDelegate, UITableViewDataSource {

    // Количество задач
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    // Отображение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configure(with: tasks[indexPath.row])
        return cell
    }

    // Обычный тап → переключаем completed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var task = tasks[indexPath.row]
        task.completed.toggle()

        presenter?.updateTask(task)

        tasks[indexPath.row] = task
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // Long press → контекстное меню
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]

        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath,
                                          previewProvider: {
            self.makePreviewCell(at: indexPath)
        }, actionProvider: { _ in

            let edit = UIAction(title: "Редактировать",
                                image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.presenter?.didSelectTaskForEditing(task)
            }

            let delete = UIAction(title: "Удалить",
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive) { [weak self] _ in
                self?.presenter?.deleteTask(with: task.id)
            }

            return UIMenu(title: "", children: [edit, delete])
        })
    }
}

extension ToDoListView: ToDoListViewProtocol {
    func showTasks(_ tasks: [Task]?) {
        self.tasks = tasks!
        tableView.reloadData()
    }
}

extension ToDoListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.presenter?.searchTasks(with: searchText)
        }
    }
}

// MARK: - DELETE AFTER

private func makeDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter.date(from: string) ?? Date()
}
