import Fluent
import Vapor

struct TaskManagementTaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")

        tasks.get(use: self.index)
        tasks.post(use: self.create)
        tasks.group(":taskID") { todo in
            tasks.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [TaskManagementTaskDTO] {
        try await TaskManagementTask.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> TaskManagementTaskDTO {
        let task = try req.content.decode(TaskManagementTaskDTO.self).toModel()

        try await task.save(on: req.db)
        return task.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let task = try await TaskManagementTask.find(req.parameters.get("taskID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await task.delete(on: req.db)
        return .noContent
    }
}
