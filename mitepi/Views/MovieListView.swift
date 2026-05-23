import SwiftUI
import SwiftData

struct MovieListView: View {
    let showsWatched: Bool

    @Environment(\.modelContext) private var modelContext
    @Query private var movies: [Movie]
    @State private var showingAddSheet = false

    init(showsWatched: Bool) {
        self.showsWatched = showsWatched
        _movies = Query(
            filter: #Predicate<Movie> { movie in
                movie.isWatched == showsWatched
            },
            sort: \Movie.createdAt,
            order: .reverse
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if movies.isEmpty {
                    ContentUnavailableView(
                        showsWatched ? "まだ記録がありません" : "作品を追加しよう",
                        systemImage: showsWatched ? "checkmark.circle" : "plus.circle",
                        description: Text(showsWatched ? "観た作品をチェックすると\nここに表示されます" : "みたい作品を追加してみよう")
                    )
                } else {
                    List {
                        ForEach(movies) { movie in
                            MovieRow(movie: movie)
                        }
                        .onDelete(perform: deleteMovies)
                    }
                }
            }
            .navigationTitle(showsWatched ? "みたよ" : "みたい")
            .toolbar {
                if !showsWatched {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddMovieView()
            }
        }
    }

    private func deleteMovies(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(movies[index])
        }
    }
}

private struct MovieRow: View {
    @Bindable var movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.headline)

            if !movie.memo.isEmpty {
                Text(movie.memo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                movie.isWatched.toggle()
                if movie.isWatched {
                    movie.watchedDate = .now
                } else {
                    movie.watchedDate = nil
                }
            } label: {
                Label(
                    movie.isWatched ? "未視聴に戻す" : "観た！",
                    systemImage: movie.isWatched ? "eye.slash" : "checkmark"
                )
            }
            .tint(movie.isWatched ? .orange : .green)
        }
    }
}

#Preview {
    MovieListView(showsWatched: false)
        .modelContainer(for: Movie.self, inMemory: true)
}
