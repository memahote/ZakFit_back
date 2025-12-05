import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: UserController())
    try app.register(collection: WeightController())
    try app.register(collection: ObjectiveController())
    try app.register(collection: MealController())
    try app.register(collection: FoodController())
    try app.register(collection: MealFoodController())
    try app.register(collection: ActivitiesController())
    try app.register(collection: UserActivitiesController())
    try app.register(collection: NutritionController())
}
