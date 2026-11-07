# HW3 Agent Worklog

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-07 | Codex (ChatGPT): reviewed HW3 requirements and implementation | I reviewed the suggestions about the list, detail screen, subject filtering, shared store, accessibility, tests and documentation before applying selected improvements | Source review and `git diff` |
| 2026-11-07 | Codex (ChatGPT): reviewed accessibility and detail-screen completeness | I reviewed the proposed identifiers and the recommendation to show every Student field, then kept the selected improvements. | `StudentsViewController.swift`, `StudentDetailViewController.swift` |
| 2026-11-07 | Codex (ChatGPT): reviewed bonus add/edit/delete behavior | I reviewed suggestions for form validation, shared-store mutation, list/detail refresh, and swipe-to-delete before applying them. | `StudentsViewController.swift`, `StudentDetailViewController.swift`, `StudentStore.swift` |
| 2026-11-07 | Codex (ChatGPT): reviewed test coverage | I reviewed suggestions for model/store and UI coverage, then kept tests for filtering and add/update/delete flows. | `StudentDirectoryTests.swift`, `StudentDirectoryUITests.swift` |

## Final review

- Agent/tool disclosure: Codex (ChatGPT) was used to review the implementation and propose improvements. I reviewed the suggestions before applying selected changes
- Accepted and rejected/revised recommendations: accepted accessibility, detail-field, mutation and test-coverage improvements, revised the suggestions to fit the existing UIKit MVC structure
- Exact local test command and result: `xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test` - passed locally on 2026-11-07
- Known limitation or remaining risk: CI status has not been checked yet
