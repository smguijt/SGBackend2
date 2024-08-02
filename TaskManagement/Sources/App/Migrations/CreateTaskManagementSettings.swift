import Fluent
import Foundation

struct CreateTaskManagementSettings: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("TaskManagementSettings")
            .id()
            .field("key", .string, .required)
            .field("value", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("TaskManagementSettings").delete()
    }
}

struct SeedTaskManagementSettings: AsyncMigration {
    func prepare(on db: Database) async throws {
        /* create entry */
        let settingShowToolbar = TaskManagementSettings(key: TaskManagementEnumSettings.ShowToolbar.rawValue, value: "false")
        try await settingShowToolbar.create(on: db)
        
        /* create entry */
        let settingShowMessages = TaskManagementSettings(key: TaskManagementEnumSettings.ShowMessages.rawValue, value: "false")
        try await settingShowMessages.create(on: db)
        
        /* create entry */
        let settingShowApps = TaskManagementSettings(key: TaskManagementEnumSettings.ShowApps.rawValue, value: "false")
       try await settingShowApps.create(on: db)
        
        /* create entry */
       let settingShowNotifications = TaskManagementSettings(key: TaskManagementEnumSettings.ShowNotifications.rawValue, value: "false")
       try await settingShowNotifications.create(on: db)
        
        /* create entry */
       let settingShowUpdates = TaskManagementSettings(key: TaskManagementEnumSettings.ShowUpdates.rawValue, value: "false")
       try await settingShowUpdates.create(on: db)

       /* create entry */
       let settingShowUserBox = TaskManagementSettings(key: TaskManagementEnumSettings.ShowUserBox.rawValue, value: "false")
       try await settingShowUserBox.create(on: db)
        
       /* create entry */
       let settingUseOAUTH02 = TaskManagementSettings(key: TaskManagementEnumSettings.UseOAUTH02.rawValue, value: "false")
       try await settingUseOAUTH02.create(on: db)
    }
    
    func revert(on db: Database) async throws {
        try await TaskManagementSettings.query(on: db).delete()
    }
    
}
