import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView(showsWatched: false)
                .tabItem {
                    Label("みたい", systemImage: "eye")
                }

            MovieListView(showsWatched: true)
                .tabItem {
                    Label("みたよ", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Movie.self, inMemory: true)
}
