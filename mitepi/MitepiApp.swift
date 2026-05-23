import SwiftUI
import SwiftData

@main
struct MitepiApp: App {
    let container: ModelContainer

    init() {
        container = SharedModelContainer.create()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
