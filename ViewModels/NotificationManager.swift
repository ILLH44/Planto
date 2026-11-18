
import UserNotifications

class NotificationManager {

    // Single shared instance used across the app
    static let shared = NotificationManager()

    // Ask the user for permission to show notifications
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // Schedule a notification for a plant
    func schedule(for plant: Plant) {
        // Notification content: title and message
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        // For testing: fire after 5 seconds (replace with a real time later)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // Use the plant id as the identifier so we can cancel it later
        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // Cancel the notification of a plant
    func cancel(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
}
