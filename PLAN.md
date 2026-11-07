# HW3 Student Plan

## Approach

The app uses UIKit MVC `StudentsViewController`, `StudentDetailViewController` and `SubjectStudentsViewController` are responsible for their views and user actions. One `StudentStore` is created for the root list and passed to the detail and filtered-list screens, so no screen owns a second authoritative student array.

Subject filtering is tested through `students(matchingSubject:)`: it must use
an exact, case-sensitive subject match and preserve the store order. The UI
uses SnapKit constraints, Dynamic Type-compatible text, and the required
accessibility identifiers: `studentList`, `studentCell.<student-id>`,
`studentDetails`, and `subjectButton.<subject>`.

## Milestones

- [x] Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [x] Optional add/edit/delete bonus, if attempted
- [x] Local verification and CI review - local test passed; CI is not recorded yet
- [x] Final diff and evidence review

## Verification plan

Automated coverage includes seed data, exact case-sensitive subject filtering,
add/update/delete validation and list-to-detail-to-subject UI flow.

Local verification completed on 2026-11-07: the full test suite passed using
the command below. I also manually tested the complete application flow:
opening students, viewing every detail field, filtering by subject, adding a
student, editing name and age, and deleting a student with swipe-to-delete.

Before final submission, run the exact command from the README again after the
final commit:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```
