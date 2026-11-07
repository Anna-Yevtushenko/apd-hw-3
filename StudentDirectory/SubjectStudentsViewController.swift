
import UIKit
import SnapKit

final class SubjectStudentsViewController: UIViewController {

    private let subject: String
    private let store: StudentStore
    private let tableView = UITableView()

    private var students: [Student] {
        store.students(matchingSubject: subject)
    }

    init(subject: String, store: StudentStore) {
        self.subject = subject
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = subject
        view.backgroundColor = .systemBackground

        setupTableView()
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
        tableView.accessibilityIdentifier = "subjectStudentsTableView"
    }
}

extension SubjectStudentsViewController: UITableViewDataSource {


    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        students.count
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

        let student = students[indexPath.row]

        cell.configure(with: student)

        cell.accessibilityIdentifier = "subjectStudentCell_\(indexPath.row)"

        return cell
    }

}

extension SubjectStudentsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let student = students[indexPath.row]

        let controller = StudentDetailViewController(
            student: student,
            store: store
        )

        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }
}
