import UIKit

final class BottomBarView: UIView {
    private let taskCountLabel = UILabel()
    private let addButton = UIButton.defaultButton(systemNameImage: "square.and.pencil")

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
        
        taskCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        taskCountLabel.textColor = .white
        taskCountLabel.text = "0 Задач"

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        addSubview(taskCountLabel)
        addSubview(addButton)

        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func setTaskCount(_ count: Int) {
        taskCountLabel.text = "\(count) Задач"
    }

    @objc private func addButtonTapped() {
        // Возможно, через делегат или замыкание
        print("Add tapped")
    }
}
