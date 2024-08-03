import Fluent
import Vapor

struct TaskManagementSettingsApiController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let api = routes.grouped("api")
        let settings = api.grouped("taskSettings")
        settings.get(use: self.index2)
        
        let setting = api.grouped("taskSetting")
        setting.get(use: self.index)
        setting.patch(":settingID", use: self.patch)
    }
    
    @Sendable
    func index(req: Request) async throws -> TaskManagementSettingsDTO {
        req.logger.info("TaskManagementSetting.Index")
        let mySettingsDTO: TaskManagementSettingsDTO = try await getTaskManagementSettings(req: req)
        return mySettingsDTO
    }
    
    @Sendable
    func index2(req: Request) async throws -> [TaskManagementDictDTO] {
        req.logger.info("TaskManagementSetting.Index2")
        let mySettingsDTO: [TaskManagementDictDTO] = try await TaskManagementSettings.query(on: req.db).all().map { $0.toDTO() }
        return mySettingsDTO
    }
    
    @Sendable
    func patch(req: Request) async throws -> TaskManagementSettingsDTO {
        req.logger.info("TaskManagementSettings.Patch")
        let paramId = req.parameters.get("settingID")
        req.logger.info(" -- parameter: \(String(describing: paramId))")
        guard let taskManagementSettingItem = try await TaskManagementSettings.find(req.parameters.get("settingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let postedSetting = try req.content.decode(TaskManagementDictDTO.self)
        taskManagementSettingItem.value = postedSetting.value ?? ""
        try await taskManagementSettingItem.save(on: req.db)
        
        let mySettingsDTO: TaskManagementSettingsDTO = try await getTaskManagementSettings(req: req)
        return mySettingsDTO
    }
}
