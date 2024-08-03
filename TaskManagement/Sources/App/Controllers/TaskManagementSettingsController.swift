import Foundation
import Fluent
import Vapor

struct TaskManagementTaskSettingsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("view")
        let tasks = api
        tasks.get(use: self.renderSystemSettings)
        
        tasks.get("systemsettings", use: self.renderSystemSettings)
        tasks.post("systemsettings", use: self.updateSystemSetting)
        tasks.get("usersettings", use: self.renderUserSettings)
        tasks.post("usersettings", use: self.updateUserSetting)
    }
    
    @Sendable
    func renderSystemSettings(req: Request) async throws -> View {
        
        let mySettingsDTO = try await getTaskManagementSettings(req: req)
        return try await req.view.render("TaskManagementSystemSettings", BaseContext(title: "Task Management", settings: mySettingsDTO))
    }
    
    @Sendable
    func updateSystemSetting(_ req: Request) async throws -> Response {
        req.logger.info("incomming request: \(req.body)")
        
        let body = try req.content.decode(TaskManagementDictDTO.self)
        guard let record = try await TaskManagementSettings.query(on: req.db).filter(\.$key == body.key!).first() else {
            req.logger.error("\(body.key!) has not been updated with value: \(body.value!)")
            let ret: Response = Response()
            ret.status = HTTPResponseStatus.notModified
            ret.body = Response.Body(string: "\(body.key!) has not been updated with value: \(body.value!)")
            return ret
        }
        record.value = body.value ?? ""
        _ = try await record.save(on: req.db)
        
        let ret: Response = Response()
        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(body.key!) has been updated with value: \(body.value!)")
        req.logger.info("\(body.key!) has been updated with value: \(body.value!)")
        return ret
    }

    @Sendable
    func renderUserSettings(req: Request) async throws -> View {
       var userIdString = try? req.query.get(String.self, at: "userid")
       if (userIdString == nil) {
           //userIdString = req.session.data["sgsoftware_systemuser"] ?? ""
           //req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
       }
       let userId = UUID(uuidString: userIdString ?? "") ?? UUID()

       let mySettingsDTO = try await getTaskManagementUserSettings(req: req, userId: userId)
       req.logger.info("userSettings retrieved: \(mySettingsDTO)")
       return try await req.view.render("TaskManagementUserSettings", BaseContext(title: "Task Management", settings: mySettingsDTO))
    }
       
    @Sendable
    func updateUserSetting(_ req: Request) async throws -> Response {

       var userIdString = try? req.query.get(String.self, at: "userid")
       var userId = UUID()

       if (userIdString == nil) {
           //userIdString = req.session.data["sgsoftware_systemuser"]
           //req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "no value")")
       }
       if userIdString != nil {
           userId = UUID(uuidString: userIdString ?? "") ?? UUID()
       }
       
       let body = try req.content.decode(TaskManagementDictDTO.self)
       guard let record: TaskManagementUserSettings = try await TaskManagementUserSettings
           .query(on: req.db)
           .filter(\.$key == body.key!)
           .filter(\.$userId == userId)
           .first()
       else {
           req.logger.error("\(body.key!) has not been updated with value: \(body.value!)")
           let ret: Response = Response()
           ret.status = HTTPResponseStatus.notModified
           ret.body = Response.Body(string: "\(body.key!) has not been updated with value: \(body.value!)")
           return ret
       }
       record.value = body.value ?? ""
       _ = try await record.save(on: req.db)
       
       let ret: Response = Response()
       ret.status = HTTPResponseStatus.accepted
       ret.body = Response.Body(string: "\(body.key!) has been updated with value: \(body.value!)")
       req.logger.info("\(body.key!) has been updated with value: \(body.value!)")
       return ret
    }

    
}
