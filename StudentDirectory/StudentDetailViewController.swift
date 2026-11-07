
import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {

    private var student: Student
    private let store: StudentStore

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    init(student: Student, store: StudentStore) {
        self.student = student
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Student Profile"
        view.backgroundColor = .systemGroupedBackground
        view.accessibilityIdentifier = "studentDetails"

        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshStudentIfNeeded()
    }

    private func setupUI() {
        scrollView.alwaysBounceVertical = true

        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .fill

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
                .inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide)
                .offset(-40)
        }

        setupHeader()
        setupInfoCards()
        setupMetadata()
        setupSubjects()
    }

    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editStudentTapped)
        )
        editButton.accessibilityIdentifier = "editStudentButton"
        navigationItem.rightBarButtonItem = editButton
    }

    @objc private func editStudentTapped() {
        let alert = UIAlertController(
            title: "Edit student",
            message: "Update the name and age.",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.text = self.student.name
            textField.autocapitalizationType = .words
            textField.accessibilityIdentifier = "editStudentNameField"
        }
        alert.addTextField { textField in
            textField.text = String(self.student.age)
            textField.keyboardType = .numberPad
            textField.accessibilityIdentifier = "editStudentAgeField"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let name = alert?.textFields?[0].text,
                  let ageText = alert?.textFields?[1].text,
                  let age = Int(ageText) else {
                self?.presentError("Enter a valid positive whole-number age.")
                return
            }

            do {
                try self.store.updateStudent(id: self.student.id, name: name, age: age)
                self.refreshStudentIfNeeded()
            } catch StudentStoreError.blankName {
                self.presentError("Name cannot be blank.")
            } catch StudentStoreError.nonPositiveAge {
                self.presentError("Age must be greater than zero.")
            } catch {
                self.presentError("Unable to update the student.")
            }
        })

        present(alert, animated: true)
    }

    private func refreshStudentIfNeeded() {
        guard let updatedStudent = store.students.first(where: { $0.id == student.id }),
              updatedStudent != student else {
            return
        }

        student = updatedStudent
        contentStack.arrangedSubviews.forEach { view in
            contentStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        setupHeader()
        setupInfoCards()
        setupMetadata()
        setupSubjects()
    }

    private func presentError(_ message: String) {
        let alert = UIAlertController(
            title: "Invalid student",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func setupHeader() {
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 12

        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: student.avatarName)
            ?? UIImage(systemName: "person.circle.fill")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 55
        avatarImageView.tintColor = .systemBlue

        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(110)
        }

        let nameLabel = UILabel()
        nameLabel.text = student.name
        nameLabel.font = .preferredFont(forTextStyle: .largeTitle)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0

        headerStack.addArrangedSubview(avatarImageView)
        headerStack.addArrangedSubview(nameLabel)

        if student.isScholarshipHolder {
            let scholarshipLabel = UILabel()
            scholarshipLabel.text = "★ Scholarship holder"
            scholarshipLabel.textColor = .systemGreen
            scholarshipLabel.font = .preferredFont(
                forTextStyle: .subheadline
            )
            scholarshipLabel.adjustsFontForContentSizeCategory = true
            scholarshipLabel.textAlignment = .center

            headerStack.addArrangedSubview(scholarshipLabel)
        }

        contentStack.addArrangedSubview(headerStack)
    }

    private func setupInfoCards() {
        let cardsStack = UIStackView()
        cardsStack.axis = .horizontal
        cardsStack.spacing = 12
        cardsStack.distribution = .fillEqually

        let ageCard = makeInfoCard(
            title: "Age",
            value: "\(student.age)"
        )

        let gradeCard = makeInfoCard(
            title: "Average grade",
            value: String(format: "%.1f", student.averageGrade)
        )

        cardsStack.addArrangedSubview(ageCard)
        cardsStack.addArrangedSubview(gradeCard)

        contentStack.addArrangedSubview(cardsStack)
    }

    private func makeInfoCard(
        title: String,
        value: String
    ) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .preferredFont(forTextStyle: .title2)
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontForContentSizeCategory = true

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        card.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        return card
    }

    private func setupSubjects() {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 12

        let titleLabel = UILabel()
        titleLabel.text = "Subjects"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true

        sectionStack.addArrangedSubview(titleLabel)

        if student.subjects.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No subjects"
            emptyLabel.textColor = .secondaryLabel
            sectionStack.addArrangedSubview(emptyLabel)
        } else {
            for subject in student.subjects {
                let button = makeSubjectButton(subject)
                sectionStack.addArrangedSubview(button)
            }
        }

        contentStack.addArrangedSubview(sectionStack)
    }

    private func setupMetadata() {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 12

        let titleLabel = UILabel()
        titleLabel.text = "Student details"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        sectionStack.addArrangedSubview(titleLabel)

        sectionStack.addArrangedSubview(
            makeMetadataRow(title: "ID", value: student.id.uuidString)
        )
        sectionStack.addArrangedSubview(
            makeMetadataRow(title: "Avatar name", value: student.avatarName)
        )
        sectionStack.addArrangedSubview(
            makeMetadataRow(
                title: "Scholarship holder",
                value: student.isScholarshipHolder ? "Yes" : "No"
            )
        )

        contentStack.addArrangedSubview(sectionStack)
    }

    private func makeMetadataRow(title: String, value: String) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        stack.backgroundColor = .secondarySystemGroupedBackground
        stack.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.adjustsFontForContentSizeCategory = true

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .preferredFont(forTextStyle: .footnote)
        valueLabel.adjustsFontForContentSizeCategory = true
        valueLabel.numberOfLines = title == "ID" ? 1 : 0
        valueLabel.adjustsFontSizeToFitWidth = title == "ID"
        valueLabel.minimumScaleFactor = 0.7

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        return stack
    }

    private func makeSubjectButton(_ subject: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = subject
        configuration.image = UIImage(
            systemName: "chevron.right"
        )
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 12
        configuration.baseBackgroundColor = .secondarySystemGroupedBackground
        configuration.baseForegroundColor = .label
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading

        button.accessibilityIdentifier = "subjectButton.\(subject)"

        button.addAction(
            UIAction { [weak self] _ in
                self?.openSubject(subject)
            },
            for: .touchUpInside
        )

        return button
    }

    private func openSubject(_ subject: String) {
        let controller = SubjectStudentsViewController(
            subject: subject,
            store: store
        )

        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }
}
