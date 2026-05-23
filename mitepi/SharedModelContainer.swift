import SwiftData

struct SharedModelContainer {
    static let appGroupID = "group.com.mitepi.app"

    static func create() -> ModelContainer {
        let config = ModelConfiguration(
            groupContainer: .identifier(appGroupID)
        )
        do {
            return try ModelContainer(for: Movie.self, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
