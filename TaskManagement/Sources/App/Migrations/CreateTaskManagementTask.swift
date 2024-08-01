import Fluent

struct CreateTaskManagementTask: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("TaskManagementTask")
            .id()
            .field("title", .string, .required)
            .field("description", .string)
            .field("userId", .uuid)
            .field("completed", .bool)
            .field("createdAt", .datetime, .required)
            .field("updatedAt", .datetime, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("TaskManagementTask").delete()
    }
}
