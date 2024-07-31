import Fluent

struct CreateTaskManagementTask: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("TaskManagementTask")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("TaskManagementTask").delete()
    }
}
