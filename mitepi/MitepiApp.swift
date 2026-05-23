import SwiftUI
import SwiftData

@main
struct MitepiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Movie.self)
    }
}
