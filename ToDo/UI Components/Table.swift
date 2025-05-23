import UIKit

extension UITableView {
    static func ToDoList() -> UITableView {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false

        return tv
    }
}

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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            stack.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        noteLabel.text = task.note
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: task.date)
        
        if task.isDone {
            checkBox.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox.tintColor = .systemYellow
            
            let attributedTitle = NSAttributedString(string: task.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray])
            let attributedNote = NSAttributedString(string: task.note ?? "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray])
            titleLabel.attributedText = attributedTitle
            noteLabel.attributedText = attributedNote
            dateLabel.textColor = .gray
        } else {
            checkBox.image = UIImage(systemName: "circle")
            checkBox.tintColor = .gray

            titleLabel.attributedText = nil
            noteLabel.attributedText = nil
            titleLabel.text = task.title
            noteLabel.text = task.note
            dateLabel.textColor = .lightGray
        }
    }
}
