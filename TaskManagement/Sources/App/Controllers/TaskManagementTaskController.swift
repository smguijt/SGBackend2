import Fluent
import Vapor

struct TaskManagementTaskController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        tasks.get(use: self.index)
        
        let task = routes.grouped("task")
        task.post(use: self.create)
        task.get(":taskID", use: self.single)
        task.patch(":taskID", use: self.patch)
        task.delete(":taskID", use: self.delete)

    }

    @Sendable
    func index(req: Request) async throws -> [TaskManagementTaskDTO] {
        req.logger.info("TaskManagementTask.Index")
        return try await TaskManagementTask.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> TaskManagementTaskDTO {
        req.logger.info("TaskManagementTask.Create")
        let task = try req.content.decode(TaskManagementTaskDTO.self).toModel()
        task.createdAt = Date()
        task.updatedAt = Date()

        try await task.save(on: req.db)
        return task.toDTO()
    }
    
    @Sendable
    func single(req: Request) async throws -> TaskManagementTaskDTO {
        req.logger.info("TaskManagementTask.Single")
        let paramTaskId = req.parameters.get("taskID")
        req.logger.info(" -- parameter: \(String(describing: paramTaskId))")
        guard let task = try await TaskManagementTask.find(req.parameters.get("taskID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return task.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        req.logger.info("TaskManagementTask.Delete")
        let paramTaskId = req.parameters.get("taskID")
        req.logger.info(" -- parameter: \(String(describing: paramTaskId))")
        guard let task = try await TaskManagementTask.find(req.parameters.get("taskID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await task.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func patch(req: Request) async throws -> TaskManagementTaskDTO {
        req.logger.info("TaskManagementTask.Patch")
        let paramTaskId = req.parameters.get("taskID")
        req.logger.info(" -- parameter: \(String(describing: paramTaskId))")
        guard let task = try await TaskManagementTask.find(req.parameters.get("taskID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let postedTask = try req.content.decode(TaskManagementTaskDTO.self)
    
        if postedTask.title != nil {
            task.title = postedTask.title
        }
        if postedTask.description != nil {
            task.description = postedTask.description
        }
        if postedTask.completed != nil {
            task.completed = postedTask.completed
        }
        if postedTask.updatedAt != nil {
            task.updatedAt = postedTask.updatedAt
        } else {
            task.updatedAt = Date()
        }
        
        if postedTask.userId != nil {
           task.userId = postedTask.userId
        }
        
        try await task.save(on: req.db)
        return task.toDTO()
    }
}
