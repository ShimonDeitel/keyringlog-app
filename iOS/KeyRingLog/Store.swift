import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [KeyRingLogItem] = []
    @Published var isPro: Bool = false

    /// Free tier limit. Kept comfortably above seed count so a fresh install
    /// never immediately hits the paywall.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("keyringlog_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: KeyRingLogItem) {
        items.append(item)
        save()
    }

    func update(_ item: KeyRingLogItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: KeyRingLogItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func seedIfNeeded() -> [KeyRingLogItem] {
        [
            KeyRingLogItem(name: "Front Door", detail: "Main Entrance", extra: "Self", date: Date()),
            KeyRingLogItem(name: "Garage", detail: "Side Garage", extra: "Spouse", date: Date()),
            KeyRingLogItem(name: "Mailbox", detail: "Curb", extra: "Self", date: Date())
        ]
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([KeyRingLogItem].self, from: data) else {
            items = seedIfNeeded()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
