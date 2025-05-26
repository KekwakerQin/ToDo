import UIKit

// Кастомный бар снизу (словно в Navigator)
final class BottomBarView: UIView {
    private let taskCountLabel = UILabel.low("0 Задач")
    private let addButton = UIButton(type: .system)
    var presenter: ToDoListPresenterProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor(named: "BackgroundColor")
        
        addButton.tintColor = .yellow
        addButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        addSubview(taskCountLabel)
        addSubview(addButton)

        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            taskCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            addButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func createButtonTapped() {
        presenter?.didTapCreateButton()
    }
}
