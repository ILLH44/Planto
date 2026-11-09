import UserNotifications

class NotificationManager {

    // Single shared instance used across the app
    static let shared = NotificationManager()

    // Hour of the day when reminders fire (9:00 AM)
    private let reminderHour = 9

    // How many future reminders to schedule for multi-day intervals
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

        // First reminder: today at 9:00 if still ahead, otherwise tomorrow at 9:00
        var first = calendar.date(bySettingHour: reminderHour, minute: 0, second: 0, of: Date()) ?? Date()
        if first <= Date() {
            first = calendar.date(byAdding: .day, value: 1, to: first) ?? first
        }

        // Every day: one repeating notification is enough
        if days == 1 {
            let time = calendar.dateComponents([.hour, .minute], from: first)
            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
            add(content, id: "\(plant.id.uuidString)-0", trigger: trigger)
            return
        }

        // Other intervals: schedule many separate notifications, N days apart
        for i in 0..<scheduledCount {
            guard let date = calendar.date(byAdding: .day, value: i * days, to: first) else { continue }
            let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            add(content, id: "\(plant.id.uuidString)-\(i)", trigger: trigger)
        }
    }

    // Cancel every notification that belongs to a plant
    func cancel(for plant: Plant) {
        var ids = ["\(plant.id.uuidString)-0"]
        for i in 0..<scheduledCount { ids.append("\(plant.id.uuidString)-\(i)") }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ids)
    }

    // Helper to create and add one request
    private func add(_ content: UNNotificationContent, id: String, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
