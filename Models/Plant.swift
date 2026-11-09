import Foundation

// Data model: describes a single plant (data only, no UI)
struct Plant: Identifiable {
    // Unique id that never changes, even if the plant is edited.
    // It is also used as the notification identifier.
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var water: String
    // How often to water: "Every day", "Every 2 days", "Once a week", ...
    var wateringDays: String = "Every day"
    // Whether the plant has been watered today
    var isWatered = false
}
