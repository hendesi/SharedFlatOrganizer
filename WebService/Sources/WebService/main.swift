import Apodini
import ApodiniDatabase
import ApodiniNotifications
import Foundation
import ApodiniREST

struct TestWebService: Apodini.WebService {
    @PathParameter var userId: UUID
    @PathParameter var deviceID: String
    
    var content: some Component {
        Group("api", "users") {
            CreateAll<User>()
                .operation(.create)
                .response(SequenceTransformer())
            Group($userId) {
                ReadAll<User>()
                    .operation(.read)
                    .response(FilterTransformer($userId))
                UpdateTasksForUserHandler(userID: $userId)
                    .operation(.update)
                    .response(SequenceTransformer())
            }
        }
        Group("api", "tasks") {
            CreateAll<Task>()
                .operation(.create)
            UpdateUsersWithInitialTasksHandler()
                .operation(.update)
        }
        Group("api", "devices", $deviceID) {
            RegisterDeviceHandler(deviceID: $deviceID)
                .operation(.create)
        }
    }
    
    var configuration: Configuration {
        DatabaseConfiguration(.defaultMongoDB("mongodb://localhost:27017/vapor_database"))
            .addMigrations(CreateTask())
            .addMigrations(CreateUser())
        ExporterConfiguration()
                    .exporter(RESTInterfaceExporter.self)
        HTTPConfiguration()
            .address(.hostname("0.0.0.0", port: 8080))
        APNSConfiguration(
            .pem(pemPath: "/Users/felixdesiderato/Documents/Uni/3. Semester/Server-side Swift/ExampleProject/WebService/dev.pem"),
            topic: "de.tum.in.ase.apodinidatabaseexampleapp",
            environment: .sandbox
        )
    }
}
 
try TestWebService.main()
