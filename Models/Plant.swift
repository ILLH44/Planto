import Foundation

// Data model: describes a single plant (data only, no UI)
// Codable lets us save and load plants as JSON
struct Plant: Identifiable, Codable {
    // Unique id that never changes, even if the plant is edited.
    // It is also used as the notification identifier.
    let id: UUID
    var name: String
    var room: String
    var light: String
    var water: String
    // How often to water: "Every day", "Every 2 days", ...
    var wateringDays: String
    // Whether the plant has been watered today
    var isWatered: Bool

    init(id: UUID = UUID(),
         name: String,
         room: String,
         light: String,
         water: String,
         wateringDays: String = "Every day",
         isWatered: Bool = false) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.water = water
        self.wateringDays = wateringDays
        self.isWatered = isWatered
    }
}
