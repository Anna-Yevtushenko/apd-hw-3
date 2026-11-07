import XCTest

final class StudentDirectoryUITests: XCTestCase {
    func testStarterApplicationLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }

    func testStudentListOpensDetailsAndSubjectFilter() {
        let app = XCUIApplication()
        app.launch()

        let studentID = "00000000-0000-0000-0000-000000000001"
        let studentList = app.tables["studentList"]
        let adaCell = app.cells["studentCell.\(studentID)"]

        XCTAssertTrue(studentList.exists)
        XCTAssertTrue(adaCell.exists)
        adaCell.tap()

        XCTAssertTrue(app.otherElements["studentDetails"].exists)
        XCTAssertTrue(app.staticTexts[studentID].exists)

        app.buttons["subjectButton.Algorithms"].tap()

        XCTAssertTrue(app.navigationBars["Algorithms"].exists)
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["Alan Turing"].exists)
    }

    func testAddingStudentUpdatesList() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["addStudentButton"].tap()

        let nameField = app.textFields["addStudentNameField"]
        let ageField = app.textFields["addStudentAgeField"]
        nameField.tap()
        nameField.typeText("Test Student")
        ageField.tap()
        ageField.typeText("30")
        app.alerts["Add student"].buttons["Add"].tap()

        XCTAssertTrue(app.staticTexts["Test Student"].exists)
        XCTAssertTrue(app.staticTexts["Age: 30 • Grade: 0.0"].exists)
    }

    func testSwipeToDeleteRemovesStudentFromList() {
        let app = XCUIApplication()
        app.launch()

        let studentID = "00000000-0000-0000-0000-000000000001"
        let adaCell = app.cells["studentCell.\(studentID)"]
        XCTAssertTrue(adaCell.exists)

        adaCell.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(adaCell.exists)
    }
}
