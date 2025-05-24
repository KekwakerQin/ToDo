import XCTest
@testable import ToDo

final class ToDoSerciveTests: XCTestCase {
    func testLoadTasksReturnData() {
        let service = ToDoListService()
        let tasks = service.getTasksFromJSON()
//        
        XCTAssertNotNil(tasks, "Tasks loaded")
        XCTAssertFalse(tasks!.isEmpty, "Array could not be emtpy")
    }
}
