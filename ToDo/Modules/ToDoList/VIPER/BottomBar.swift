import UIKit

final class BottomBarView: UIView {
    private let taskCountLabel = UILabel.low("0 Задач")
    private let addButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor(named: "BackgroundColor")
        
        addButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addButton.tintColor = .yellow
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
        print("tapped")
    }
}
