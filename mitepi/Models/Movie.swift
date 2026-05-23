import Foundation
import SwiftData

@Model
final class Movie {
    var title: String
    var memo: String
    var isWatched: Bool
    var watchedDate: Date?
    var createdAt: Date

    init(title: String, memo: String = "", isWatched: Bool = false, watchedDate: Date? = nil) {
        self.title = title
        self.memo = memo
        self.isWatched = isWatched
        self.watchedDate = watchedDate
        self.createdAt = .now
    }
}
