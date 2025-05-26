import UIKit

// Базовый вид таблицы (можно расширить просто)
extension UITableView {
    static func ToDoList() -> UITableView {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(named: "BackgroundColor")
        
        return tv
    }
}

// Ячейка
class TaskCell: UITableViewCell {
    let checkBox = UIImageView()
    let titleLabel = UILabel.body(nil)
    let noteLabel = UILabel.low(nil)
    let dateLabel = UILabel.low(nil)
    
    private let stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.contentMode = .scaleAspectFit
        
        noteLabel.numberOfLines = 2
        
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(noteLabel)
        stack.addArrangedSubview(dateLabel)
        
        contentView.addSubview(checkBox)
        contentView.addSubview(stack)
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 34),
            checkBox.heightAnchor.constraint(equalToConstant: 34),
            
            stack.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with task: Task) {
        titleLabel.attributedText = nil
        noteLabel.attributedText = nil
        
        titleLabel.textColor = .label
        noteLabel.textColor = .secondaryLabel
        dateLabel.textColor = .lightGray
        
        titleLabel.text = task.title
        noteLabel.text = task.todo
        dateLabel.text = task.date
        
        if task.completed {
            checkBox.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox.tintColor = .systemYellow
            
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            
            noteLabel.attributedText = NSAttributedString(
                string: task.todo ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            
            dateLabel.textColor = .gray
        } else {
            checkBox.image = UIImage(systemName: "circle")
            checkBox.tintColor = .gray
        }
    }
}
