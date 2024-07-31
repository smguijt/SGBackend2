@testable import App
import XCTVapor
import Fluent


final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        try await configure(app)
        try await app.autoMigrate()
    }
    
    override func tearDown() async throws { 
        try await app.autoRevert()
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    func testHelloWorld() async throws {
        try await self.app.test(.GET, "hello", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    func testTaskManagementTaskIndex() async throws {
        let sampleTasks = [TaskManagementTask(title: "sample1"), TaskManagementTask(title: "sample2")]
        try await sampleTasks.create(on: self.app.db)
        
        try await self.app.test(.GET, "tasks", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(
                try res.content.decode([TaskManagementTaskDTO].self).sorted(by: { $0.title ?? "" < $1.title ?? "" }),
                sampleTasks.map { $0.toDTO() }.sorted(by: { $0.title ?? "" < $1.title ?? "" })
            )
        })
    }
    
    func testTaskManagementTaskCreate() async throws {
        let newDTO = TaskManagementTaskDTO(id: nil, title: "test")
        
        try await self.app.test(.POST, "todos", beforeRequest: { req in
            try req.content.encode(newDTO)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let models = try await TaskManagementTask.query(on: self.app.db).all()
            XCTAssertEqual(models.map { $0.toDTO().title }, [newDTO.title])
        })
    }
    
    /*
    func testTaskManagementTaskDelete() async throws {
        let testTasks = [TaskManagementTask(title: "test1"), TaskManagementTask(title: "test2")]
        try await testTasks.create(on: app.db)
        
        try await self.app.test(.DELETE, "tasks/\(testTasks[0].requireID())", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .noContent)
            let model = try await TaskManagementTask.find(TaskManagementTask[0].id, on: self.app.db)
            XCTAssertNil(model)
        })
    }
    */
}


extension TaskManagementTaskDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

