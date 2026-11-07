import XCTest
@testable import StudentDirectory

final class StarterStudentDirectoryTests: XCTestCase {
    func testStarterStoreIsConstructible() {
        XCTAssertEqual(StudentStore().students.count, 10)
    }

    func testStarterSeedDataHasOverlappingSubjects() {
        let counts = StudentSeedData.students.flatMap(\.subjects).reduce(into: [:]) { counts, subject in
            counts[subject, default: 0] += 1
        }
        XCTAssertTrue(counts.values.contains(where: { $0 > 1 }))
    }

    func testAddStudentAppendsDefaultStudent() throws {
        let store = StudentStore(students: [])

        try store.addStudent(name: "Linus Torvalds", age: 25)

        let student = try XCTUnwrap(store.students.first)
        XCTAssertEqual(student.name, "Linus Torvalds")
        XCTAssertEqual(student.age, 25)
        XCTAssertEqual(student.averageGrade, 0)
        XCTAssertFalse(student.isScholarshipHolder)
        XCTAssertEqual(student.subjects, [])
        XCTAssertEqual(student.avatarName, "avatar-default")
    }

    func testAddStudentRejectsBlankNameWithoutMutation() {
        let store = StudentStore(students: [])

        XCTAssertThrowsError(try store.addStudent(name: "   ", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertTrue(store.students.isEmpty)
    }

    func testDeleteStudentRemovesMatchingStudent() throws {
        let student = StudentSeedData.students[0]
        let store = StudentStore(students: [student])

        try store.deleteStudent(id: student.id)

        XCTAssertTrue(store.students.isEmpty)
    }

    func testDeleteUnknownStudentDoesNotMutateStore() {
        let student = StudentSeedData.students[0]
        let store = StudentStore(students: [student])
        let unknownID = UUID(uuidString: "00000000-0000-0000-0000-000000000099")!

        XCTAssertThrowsError(try store.deleteStudent(id: unknownID)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }
        XCTAssertEqual(store.students, [student])
    }

    func testUpdateStudentChangesOnlyNameAndAge() throws {
        let original = StudentSeedData.students[0]
        let store = StudentStore(students: [original])

        try store.updateStudent(id: original.id, name: "Ada Byron", age: 21)

        let updated = try XCTUnwrap(store.students.first)
        XCTAssertEqual(updated.name, "Ada Byron")
        XCTAssertEqual(updated.age, 21)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
    }

    func testUpdateStudentRejectsInvalidAgeWithoutMutation() {
        let original = StudentSeedData.students[0]
        let store = StudentStore(students: [original])

        XCTAssertThrowsError(
            try store.updateStudent(id: original.id, name: "Changed", age: 0)
        ) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertEqual(store.students, [original])
    }

    func testMatchingSubjectPreservesStoreOrderAndUsesExactCase() {
        let first = StudentSeedData.students[0]
        let second = StudentSeedData.students[1]
        let third = StudentSeedData.students[2]
        let store = StudentStore(students: [first, second, third])

        XCTAssertEqual(
            store.students(matchingSubject: "Algorithms").map(\.id),
            [first.id, second.id, third.id]
        )
        XCTAssertTrue(store.students(matchingSubject: "algorithms").isEmpty)
    }

    func testAddStudentRejectsNonPositiveAgeWithoutMutation() {
        let store = StudentStore(students: [])

        XCTAssertThrowsError(try store.addStudent(name: "Ada", age: 0)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertTrue(store.students.isEmpty)
    }

    func testUpdateUnknownStudentDoesNotMutateStore() {
        let original = StudentSeedData.students[0]
        let store = StudentStore(students: [original])
        let unknownID = UUID(uuidString: "00000000-0000-0000-0000-000000000099")!

        XCTAssertThrowsError(
            try store.updateStudent(id: unknownID, name: "Changed", age: 20)
        ) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknownID))
        }
        XCTAssertEqual(store.students, [original])
    }
}
