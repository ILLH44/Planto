import SwiftUI

@Observable
class PlantsViewModel {

    // MARK: - Data

    // The list of plants; the screen updates whenever it changes
    var plants: [Plant] = []

    // MARK: - Computed values (update automatically)

    // Number of plants that have been watered
    var wateredCount: Int {
        plants.filter(\.isWatered).count
    }

    // Progress from 0.0 to 1.0 (avoids dividing by zero when empty)
    var progress: Double {
        plants.isEmpty ? 0 : Double(wateredCount) / Double(plants.count)
    }

    // True when there are plants and all of them are watered
    var allDone: Bool {
        !plants.isEmpty && wateredCount == plants.count
    }
    // Pending plants first, watered plants at the bottom
    var sortedPlants: [Plant] {
        plants.filter { !$0.isWatered } + plants.filter { $0.isWatered }
    }

    // Message shown above the progress bar
    var statusMessage: String {
        wateredCount == 0
        ? "Your plants are waiting for a sip 💦"
        : "\(wateredCount) of your plants feel loved today ✨"
    }

    // MARK: - Actions

    // Add a new plant and schedule its notification
    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.shared.schedule(for: plant)
    }

    // Replace an edited plant (same id) and reschedule its notification
    func update(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i] = plant
            NotificationManager.shared.schedule(for: plant)
        }
    }

    // Remove a plant and cancel its notification
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.shared.cancel(for: plant)
    }

    // Flip the watered state of a plant
    func toggleWatered(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i].isWatered.toggle()
        }
    }
}
