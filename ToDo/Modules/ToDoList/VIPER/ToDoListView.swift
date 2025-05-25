import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task]?)
}

class ToDoListView: UIViewController {
    
    // MARK: - Components
    
    var presenter: ToDoListPresenterProtocol?
    
    private let searchBar = UISearchBar.generalWrapper()
    private let label = UILabel.title("Заголовок")
    private let tableView = UITableView.ToDoList()
    private var tasks: [Task] = []

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        presenter?.viewDidLoad()

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
    }

    // MARK: - Constraints
    
    private func addConstraints() {
        labelSetupConstraints()
        searchBarSetupConstraints()
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func anyAction() {
        print("Tapped button")
    }
    
    // MARK: Search bar manipulate
    
//    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        searchBar.resignFirstResponder()
//    }
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].completed.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ToDoListView: ToDoListViewProtocol {
    func showTasks(_ tasks: [Task]?) {
        self.tasks = tasks!
        tableView.reloadData()
    }
}

// MARK: - DELETE AFTER

private func makeDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter.date(from: string) ?? Date()
}
