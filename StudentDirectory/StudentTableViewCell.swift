
import UIKit
import SnapKit

final class StudentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "StudentCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let scholarshipLabel = UILabel()

    private let textStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 28

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        detailsLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailsLabel.textColor = .secondaryLabel

        scholarshipLabel.font = .preferredFont(forTextStyle: .caption1)
        scholarshipLabel.textColor = .systemGreen

        [nameLabel, detailsLabel, scholarshipLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
        }

        textStack.axis = .vertical
        textStack.spacing = 4

        [nameLabel, detailsLabel, scholarshipLabel].forEach {
            textStack.addArrangedSubview($0)
        }

        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }

        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
        }

        accessoryType = .disclosureIndicator
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName)
            ?? UIImage(systemName: "person.circle.fill")

        nameLabel.text = student.name
        detailsLabel.text = "Age: \(student.age) • Grade: \(student.averageGrade)"

        scholarshipLabel.text = student.isScholarshipHolder
            ? "★ Scholarship holder"
            : nil

        scholarshipLabel.isHidden = !student.isScholarshipHolder
    }
}
