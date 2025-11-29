import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "127.0.0.1",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "Zakfit"
    ), as: .mysql)
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin],
        cacheExpiration: 500
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)

//    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(UpdateUserAddBirthDate())
    app.migrations.add(CreateWeight())
    app.migrations.add(CreateObjective())
    app.migrations.add(UpdateObjective())
    app.migrations.add(CreateMeal())
    app.migrations.add(CreateFood())
    app.migrations.add(CreateMealFood())
    app.migrations.add(AddTypeToFood())
    
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
