import UIKit

// Енам для отслеживания создания или редактирования задачи
enum CreateTaskMode {
    case create
    case edit(task: Task)
}

final class CreateTaskViewController: UIViewController {
    
    // MARK: - Components
    
    var presenter: CreateTaskPresenterProtocol?
    var mode: CreateTaskMode = .create

    // MARK: - UI
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.preferredFont(forTextStyle: .title1)
        tv.backgroundColor = .clear
        tv.textColor = UIColor(named: "TextColor")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(textView)
        textView.delegate = self
        addConstraints()
        
        navigationItem.title = "Задача"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Вернуться",
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        
        if case let .edit(task) = mode {
            let combined = [task.title ?? "", task.todo ?? ""].joined(separator: "\n")
            textView.text = combined.trimmingCharacters(in: .whitespacesAndNewlines)
            applyDynamicStyle()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Setups
    // MARK: - Constraints
    
    private func addConstraints() {
        textViewSetupConstraints()
    }
    
    private func textViewSetupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        let rawText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let lines = rawText.components(separatedBy: .newlines)
        
        // Проверки на пустоту данных (понадобится в дальнейшем)
        let hasTitle = lines.first?.isEmpty == false
        let hasBody = lines.dropFirst().contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        switch mode {
        case .create:
            // Задача может существовать с одним параметром из них, но если ни того, ни другого нет, то задача буквально ничего не значит = не создавать
            if hasTitle || hasBody {
                presenter?.handleBackWithRawText(rawText)
            }
            navigationController?.popViewController(animated: true)
            
        case .edit(let task):
            // Вызов алерта (предупреждения), что если пользователь удалит все данные, задача удалится.
            if !hasTitle && !hasBody {
                /*
                 Алерт на такой случай с тремя кейсами:
                   - Не сохранять: данные будут возвращены, вдруг пользователь случайно удалил все
                   - Удалить задачу: просто стерем ее из бд
                   - Отмена: не переходим назад, продолжаем редактировать
                 */
                showDeleteAlert(for: task)
            } else {
                /*
                 В этом случае мы просто сохраним изменения пользователя
                 Однако, место для улучшения: вызвать другой алерт, который
                 спрашивает у пользователя: Данные были изменены. Сохранить?
                 Отмена, нет, да
                 */
                presenter?.handleUpdate(for: task, withRawText: rawText)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showDeleteAlert(for task: Task) {
        let alert = UIAlertController(
            title: "Удалить задачу?",
            message: "Задача не содержит данных, она будет автоматически удалена",
            preferredStyle: .alert
        )
        
        // Отмена, закрыть алерт окно
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        // Отменить изменения задачи
        alert.addAction(UIAlertAction(title: "Не сохранять", style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        // Удалить задачу
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.presenter?.deleteTask(task)
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
}

// MARK: - Extensions

// Экстеншон для текстВьюшки, чтобы автоматически определить стили и сделать запрос в бд через проверку
extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        applyDynamicStyle()
    }
    
    private func applyDynamicStyle() {
        let rawText = textView.text ?? ""
        let lines = rawText.components(separatedBy: .newlines)
        
        let attributedText = NSMutableAttributedString()
        
        for (index, line) in lines.enumerated() {
            let font: UIFont = (index == 0)
            ? UIFont.titleFont()
            : UIFont.bodyFont()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor(named: "TextColor")!
            ]
            
            let lineWithNewline = index < lines.count - 1 ? "\(line)\n" : line
            attributedText.append(NSAttributedString(string: lineWithNewline, attributes: attributes))
        }
        
        let selected = textView.selectedRange
        textView.attributedText = attributedText
        textView.selectedRange = selected
    }
}
