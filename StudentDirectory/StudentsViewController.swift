
import UIKit
import SnapKit

final class StudentsViewController: UIViewController {

    private let store: StudentStore
    private let tableView = UITableView()

    init(store: StudentStore = StudentStore()) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Students"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.register(
            StudentTableViewCell.self,
            forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "studentList"
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addStudentTapped)
        )
        addButton.accessibilityIdentifier = "addStudentButton"
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addStudentTapped() {
        let alert = UIAlertController(
            title: "Add student",
            message: "Enter a name and a positive age.",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
            textField.accessibilityIdentifier = "addStudentNameField"
        }
        alert.addTextField { textField in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
            textField.accessibilityIdentifier = "addStudentAgeField"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let name = alert?.textFields?[0].text,
                  let ageText = alert?.textFields?[1].text,
                  let age = Int(ageText) else {
                self?.presentError("Enter a valid positive whole-number age.")
                return
            }

            do {
                try self.store.addStudent(name: name, age: age)
                self.tableView.reloadData()
            } catch StudentStoreError.blankName {
                self.presentError("Name cannot be blank.")
            } catch StudentStoreError.nonPositiveAge {
                self.presentError("Age must be greater than zero.")
            } catch {
                self.presentError("Unable to add the student.")
            }
        })

        present(alert, animated: true)
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
}

extension StudentsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        store.students.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StudentTableViewCell else {
            return UITableViewCell()
        }

        let student = store.students[indexPath.row]

        cell.configure(with: student)

        cell.accessibilityIdentifier = "studentCell.\(student.id)"

        return cell
    }
}

extension StudentsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let student = store.students[indexPath.row]

        let detailViewController = StudentDetailViewController(
            student: student,
            store: store
        )

        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else {
            return
        }

        let student = store.students[indexPath.row]

        do {
            try store.deleteStudent(id: student.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            presentError("Unable to delete the student.")
        }
    }
}
