#SGBackend2 Swift Server Application
The idea of this project is to learn about the Swift Language and put it to work on server only.
Multiple services build with the usage of the Swift Vapor Framework that are linked to each other
using WebSockets and REST integrations.


#User Management Service
- Application for maintaining users. It will setup user information like user data, user roles, user groups
- This server will be running on default port 5001, but port is changeable using environment variables.

                    
#Event Management Service
- Application for maintaining events.
- This server will be running on default port 5002, but port is changeable using environment variables.


#Task Management Service
- Application for maintaining tasks.
- This server will be running on default port 5003, but port is changeable using environment variables.
- Screen to display overview of available tasks
    - Option to change task status 
    - Oprion to create new task
    - Option to update task status
    - Option to asign task to user
    - Option to toggle only open tasks or all open task
- Screen to view history of tasks
    - Option to restore task when marked as completed

TaskManagement_Task
-------------------
Id: UUID?
Title: String?
Description: String?
userId: UUID?
Active: Bool?
CreatedAt: Date?
Completed: Bool?
Completed_By: UUID?
Completed_Date: DateTime?

TaskManagement_Task_Comments
----------------------------
Id: UUID?
Comment: String?
CreatedAt: Date?                 
Task_Id: UUID?


#Mailing Management Service
- Application for maintaining emailings.
- This server will be running on default port 5004, but port is changeable using environment
                    
Pitch:
++++++
                        
Requirements:
+++++++++++++
- Database for store mail message
- Defined port addresss -> 5004
- Mail Account

                        
                        
#Time Management Service
- Application for maintaining time projects.
- This server will be running on default port 5005, but port is changeable using environment variables.
                    
Pitch:
++++++
- Application refresh on daily basis. History will be stored and saved but only the current day items will be displayed.
- Task is added and start time is recorded. Screen should display the running time.
- When new task is added, the previous task is put on hold. Only one active task should exists.
- Application should keep track on break times. When a task is running during break time, the break time duration should be deducted from`
  the total running time.
- A report / dashboard should present each project in a graphical display
- Tasks should be created by user
- First screen should contain a list of all available tasks for given user for current date
- Clicking on task should expand and display a list of all time recordings for the given task.
  This includes start time, end time, total duration time.
  Also when select task user should be able to press a button to activate or stop selected task.
- Task list on first screen should be sortable.

Requirements:
+++++++++++++
- Database to store the data
- Defined port address -> 5005
- Postman to connect via WebSocket and via REST
- Leaf + Template for Dashboard
- Leaf + Template for Settings
- Leaf + Template for Adding and Maintaining time records

Database:
+++++++++
                        
TimeManagement_Task
-------------------
Id: UUID?
Title: String?
Description: String?
userId: UUID?
Active: Bool?
CreatedAt: Date?

TimeManagement_Task_Times
-------------------------
Id: UUID?
StartTime: Time?
EndTime: Time?
TimeManagement_Task_Id: UUID?
Active: Bool?

TimeManagement_Task_Times_Comments
----------------------------
Id: UUID?
Comment: String?
CreatedAt: Date?                 
TimeManagement_Task_Times_Id: UUID?


                        
                        
                        
                        
