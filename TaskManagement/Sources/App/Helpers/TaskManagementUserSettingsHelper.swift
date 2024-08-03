import Foundation
import Fluent
import Vapor

func getTaskManagementUserSettings(req: Request, userId: UUID) async throws -> TaskManagementSettingsDTO {
     
    var myUserSettingDTO: TaskManagementUserSettingsDTO = TaskManagementUserSettingsDTO(userId: userId)

     _ = try await TaskManagementUserSettings
            .query(on: req.db)
            .filter(\.$userId == userId)
            .all()
            .compactMap { setting in
                
                /* map ID */
                //myUserSettingDTO.ID = setting.id
                myUserSettingDTO.userId = userId
                
                /* ShowMessages*/
                if setting.key == TaskManagementEnumSettings.ShowMessages.rawValue {
                    myUserSettingDTO.ShowMessages = Bool(setting.value.lowercased()) ?? false
                }

                /* ShowApps*/
                if setting.key == TaskManagementEnumSettings.ShowApps.rawValue {
                    myUserSettingDTO.ShowApps = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowNotifications*/
                if setting.key == TaskManagementEnumSettings.ShowNotifications.rawValue {
                    myUserSettingDTO.ShowNotifications = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUpdates*/
                if setting.key == TaskManagementEnumSettings.ShowUpdates.rawValue {
                    myUserSettingDTO.ShowUpdates = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUseOAUTH02 */
                if setting.key == TaskManagementEnumSettings.UseOAUTH02.rawValue {
                    myUserSettingDTO.UseOAUTH02 = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ClientId */
                if setting.key == TaskManagementEnumSettings.ClientId.rawValue {
                    myUserSettingDTO.ClientId = String(setting.value)
                }
                
                /* ClientSecret */
                if setting.key == TaskManagementEnumSettings.ClientSecret.rawValue {
                    myUserSettingDTO.ClientSecret = String(setting.value)
                }

                return myUserSettingDTO
            }

    
    let mySystemSettings: TaskManagementSettingsDTO = try await getTaskManagementSettings(req: req)
    let mySettingDTO: TaskManagementSettingsDTO = TaskManagementSettingsDTO(ShowToolbar: mySystemSettings.ShowToolbar,
                                                ShowMessages: myUserSettingDTO.ShowMessages,
                                                ShowApps: myUserSettingDTO.ShowApps,
                                                ShowNotifications: myUserSettingDTO.ShowNotifications,
                                                ShowUpdates: myUserSettingDTO.ShowUpdates,
                                                ShowUserBox: mySystemSettings.ShowUserBox,
                                                userId: mySystemSettings.userId,
                                                UseOAUTH02: mySystemSettings.UseOAUTH02,
                                                ClientId: myUserSettingDTO.ClientId,
                                                ClientSecret: myUserSettingDTO.ClientSecret)

    return mySettingDTO
 }

