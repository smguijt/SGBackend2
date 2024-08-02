import Fluent
import Vapor

struct TaskManagementSettingsApiController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let api = routes.grouped("api")
        let settings = api.grouped("settings")
        settings.get(use: self.index)
        
        let setting = api.grouped("setting")
        setting.patch(":settingID", use: self.patch)
    }
    
    @Sendable
    func index(req: Request) async throws -> TaskManagementSettingsDTO {
        req.logger.info("TaskManagementSetting.Index")
        let mySettingsDTO: TaskManagementSettingsDTO = try await getTaskManagementSettings(req: req)
        return mySettingsDTO
    }
    
    @Sendable
    func patch(req: Request) async throws -> TaskManagementSettingsDTO {
        req.logger.info("TaskManagementSettings.Patch")
        let paramId = req.parameters.get("settingsID")
        req.logger.info(" -- parameter: \(String(describing: paramId))")
        guard let taskManagementSettingItem = try await TaskManagementSettings.find(req.parameters.get("settingsID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let postedSetting = try req.content.decode(TaskManagementDictDTO.self)
        taskManagementSettingItem.value = postedSetting.value ?? ""
        try await taskManagementSettingItem.save(on: req.db)
        
        let mySettingsDTO: TaskManagementSettingsDTO = try await getTaskManagementSettings(req: req)
        return mySettingsDTO
    }
}
