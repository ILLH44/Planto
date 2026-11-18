import UserNotifications

class NotificationManager {

    // Single shared instance used across the app
    static let shared = NotificationManager()

    // Hour of the day when reminders fire (10:00 AM)
    private let reminderHour = 10

    // How many future reminders to schedule
    private let scheduledCount = 30

    // Ask the user for permission to show notifications
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // Convert the picker choice to a number of days
    private func interval(for choice: String) -> Int {
        switch choice {
        case "Every day": return 1
        case "Every 2 days": return 2
        case "Every 3 days": return 3
        case "Once a week": return 7
        case "Every 10 days": return 10
        case "Every 2 weeks": return 14
        default: return 1
        }
    }

    // Schedule notifications for a plant based on its watering days
    func schedule(for plant: Plant) {
        // Remove old notifications first (needed when a plant is edited)
        cancel(for: plant)

        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        let calendar = Calendar.current
        let days = interval(for: plant.wateringDays)

        // Save date at the reminder hour (10:00 AM)
        let saveDay = calendar.date(bySettingHour: reminderHour, minute: 0, second: 0, of: Date()) ?? Date()

        // Schedule separate notifications, starting one interval AFTER the save date
        for i in 1...scheduledCount {
            guard let date = calendar.date(byAdding: .day, value: i * days, to: saveDay) else { continue }
            let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            add(content, id: "\(plant.id.uuidString)-\(i)", trigger: trigger)
        }
    }

    // Cancel every notification that belongs to a plant
    func cancel(for plant: Plant) {
        let ids = (0...scheduledCount).map { "\(plant.id.uuidString)-\($0)" }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ids)
    }

    // Helper to create and add one request
    private func add(_ content: UNNotificationContent, id: String, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
