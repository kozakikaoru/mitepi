import WidgetKit
import SwiftUI
import SwiftData

struct WantToWatchEntry: TimelineEntry {
    let date: Date
    let movies: [String]
}

struct MitepiWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WantToWatchEntry {
        WantToWatchEntry(date: .now, movies: ["作品タイトル"])
    }

    func getSnapshot(in context: Context, completion: @escaping (WantToWatchEntry) -> Void) {
        completion(WantToWatchEntry(date: .now, movies: ["作品タイトル"]))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WantToWatchEntry>) -> Void) {
        var movieTitles: [String] = []

        let container = try? ModelContainer(
            for: Movie.self,
            configurations: ModelConfiguration(
                groupContainer: .identifier(SharedModelContainer.appGroupID)
            )
        )
        if let context = container?.mainContext {
            let descriptor = FetchDescriptor<Movie>(
                predicate: #Predicate { !$0.isWatched },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            movieTitles = (try? context.fetch(descriptor))?.prefix(5).map(\.title) ?? []
        }

        let entry = WantToWatchEntry(date: .now, movies: movieTitles)
        let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct MitepiWidgetEntryView: View {
    var entry: WantToWatchEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("みたい")
                .font(.headline)
                .foregroundStyle(.secondary)

            if entry.movies.isEmpty {
                Text("作品を追加しよう")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(entry.movies, id: \.self) { title in
                    Text(title)
                        .font(.caption)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MitepiWidget: Widget {
    let kind = "MitepiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MitepiWidgetProvider()) { entry in
            MitepiWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("みたいリスト")
        .description("みたい作品を表示します")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
