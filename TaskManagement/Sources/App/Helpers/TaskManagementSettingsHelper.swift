import Foundation
import Fluent
import Vapor

func getTaskManagementSettings(req: Request) async throws -> TaskManagementSettingsDTO {
    /* retrieve settings */
    var mySettingDTO: TaskManagementSettingsDTO = TaskManagementSettingsDTO()
    _ = try await TaskManagementSettings.query(on: req.db).all().compactMap{ setting in
        
            /* ShowToolbar*/
            if setting.key == TaskManagementEnumSettings.ShowToolbar.rawValue {
                mySettingDTO.ShowToolbar = Bool(setting.value.lowercased()) ?? false
            }
        
            /* ShowMessages*/
            if setting.key == TaskManagementEnumSettings.ShowMessages.rawValue {
                mySettingDTO.ShowMessages = Bool(setting.value.lowercased()) ?? false
            }
        
            /* ShowApps*/
            if setting.key == TaskManagementEnumSettings.ShowApps.rawValue {
                mySettingDTO.ShowApps = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowNotifications*/
            if setting.key == TaskManagementEnumSettings.ShowNotifications.rawValue {
                mySettingDTO.ShowNotifications = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowUpdates*/
            if setting.key == TaskManagementEnumSettings.ShowUpdates.rawValue {
                mySettingDTO.ShowUpdates = Bool(setting.value.lowercased()) ?? false
            }

            /* ShowUserBox*/
            if setting.key == TaskManagementEnumSettings.ShowUserBox.rawValue {
                mySettingDTO.ShowUserBox = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowUseOAUTH02 */
            if setting.key == TaskManagementEnumSettings.UseOAUTH02.rawValue {
                mySettingDTO.UseOAUTH02 = Bool(setting.value.lowercased()) ?? false
            }
        }
    
    return mySettingDTO
}

