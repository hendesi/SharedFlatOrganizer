import Apodini
import ApodiniDatabase
import Foundation
import ApodiniREST

struct TestWebService: Apodini.WebService {
    @PathParameter var userId: UUID
    
    var content: some Component {
        Group("api", "users") {
            CreateAll<User>()
                .operation(.create)
            Group($userId) {
                ReadAll<User>()
                    .operation(.read)
                    .response(FilterTransformer($userId))
                UpdateTasksForUserHandler(userID: $userId)
                    .operation(.update)
            }
        }
        Group("api", "tasks") {
            CreateAll<Task>()
                .operation(.create)
            UpdateUsersWithInitialTasks()
                .operation(.update)
        }
        Group("api", "dummy", $userId) {
            ReadAll<User>()
                .operation(.read)
                .response(SequenceTransformer())
        }
        Group("api", "demo", "users") {
            CreateUsersWithTaskHandler()
                .operation(.create)
        }
        Group("api", "demo", "devices") {
            RegisterDevice()
        }
    }
    
    var configuration: Configuration {
        DatabaseConfiguration(.defaultMongoDB("mongodb://localhost:27017/vapor_database"))
            .addMigrations(CreateTask())
            .addMigrations(CreateUser())
        ExporterConfiguration()
                    .exporter(RESTInterfaceExporter.self)
    }
}
 
try TestWebService.main()
