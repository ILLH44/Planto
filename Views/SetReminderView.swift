import SwiftUI

struct SetReminderView: View {
    // Used to close the sheet
    @Environment(\.dismiss) private var dismiss

    // The plant being edited (nil = adding a new plant)
    var plantToEdit: Plant?
    // Called when the user taps the checkmark; hands the plant to the parent
    var onSave: (Plant) -> Void
    // Called when the user taps "Delete Reminder"
    var onDelete: () -> Void

    // User selections
    @State private var name: String
    @State private var room: String
    @State private var light: String
    @State private var wateringDays: String
    @State private var water: String

    // Options shown in the menus
    private let rooms = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    private let days = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    private let waters = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]

    // Light options: each has a name and an icon shown inside the menu
    private let lights: [(name: String, icon: String)] = [
        ("Full sun", "sun.max"),
        ("Partial sun", "sun.horizon"),
        ("Low light", "moon")
    ]

    // Background color of the cards
    private let card = Color(white: 0.17)

    // Initial values: from the plant when editing, or defaults when adding
    init(plantToEdit: Plant? = nil,
         onSave: @escaping (Plant) -> Void = { _ in },
         onDelete: @escaping () -> Void = {}) {
        self.plantToEdit = plantToEdit
        self.onSave = onSave
        self.onDelete = onDelete
        _name = State(initialValue: plantToEdit?.name ?? "")
        _room = State(initialValue: plantToEdit?.room ?? "Bedroom")
        _light = State(initialValue: plantToEdit?.light ?? "Full sun")
        _wateringDays = State(initialValue: plantToEdit?.wateringDays ?? "Every day")
        _water = State(initialValue: plantToEdit?.water ?? "20-50 ml")
    }

    var body: some View {
        ZStack {
            // Dark gray background
            Color(white: 0.11).ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar: X button, title, and checkmark button
                HStack {
                    circleButton("xmark", color: Color(white: 0.2)) { dismiss() }
                    Spacer()
                    Text("Set Reminder").font(.headline).foregroundStyle(.white)
                    Spacer()
                    // Save button is disabled and faded while the name is empty
                    circleButton("checkmark", color: Color.plantButton) { save() }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.5 : 1)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Plant name capsule
                HStack {
                    Text("Plant Name")
                        .font(.rowText)
                        .foregroundStyle(.white)
                    TextField("", text: $name, prompt: Text("Pothos").foregroundStyle(.gray))
                        .font(.rowText)
                        .foregroundStyle(.white)
                        // Cursor color (mint green like the design)
                        .tint(Color.plantMint)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(card)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.top, 30)

                // First card: Room and Light
                group {
                    row("Room", "location", $room, rooms)
                    Divider().overlay(Color.white.opacity(0.15))
                    lightRow()
                }
                // Second card: Watering Days and Water
                group {
                    row("Watering Days", "drop", $wateringDays, days)
                    Divider().overlay(Color.white.opacity(0.15))
                    row("Water", "drop", $water, waters)
                }

                // Delete button: shown only in edit mode
                if plantToEdit != nil {
                    Button {
                        onDelete()
                        dismiss()
                    } label: {
                        Text("Delete Reminder")
                            .font(.rowText)
                            .foregroundStyle(Color.deleteRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(card)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                }

                // Pushes everything to the top
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Helpers

    // Builds the plant (keeps the same id when editing), sends it to the parent, and closes
    private func save() {
        var plant = plantToEdit ?? Plant(name: "", room: "", light: "", water: "")
        plant.name = name
        plant.room = room
        plant.light = light
        plant.wateringDays = wateringDays
        plant.water = water
        onSave(plant)
        dismiss()
    }

    // Reusable round glass-style button (shine + light border + shadow)
    private func circleButton(_ icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3.weight(.medium))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background {
                    ZStack {
                        Circle().fill(color)
                        // Soft light from the top-left, fading out (glass shine)
                        Circle().fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.18), Color.white.opacity(0.0)],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 52
                            )
                        )
                    }
                }
                .overlay(
                    Circle().strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), Color.white.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                )
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    // Reusable rounded card that wraps a group of rows (tight spacing)
    private func group<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0, content: content)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            .padding(.top, 30)
    }

    // Reusable row: icon + title on the left, value + arrows on the right
    private func row(_ title: String, _ icon: String, _ selection: Binding<String>, _ options: [String]) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.rowText)
                .foregroundStyle(.white)
            Spacer()
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                valueLabel(selection.wrappedValue)
            }
        }
        .padding(.vertical, 10)
    }

    // Light row: same look, but icons appear inside the menu
    private func lightRow() -> some View {
        HStack {
            Label("Light", systemImage: "sun.max")
                .font(.rowText)
                .foregroundStyle(.white)
            Spacer()
            Menu {
                ForEach(lights, id: \.name) { item in
                    Button {
                        light = item.name
                    } label: {
                        Label(item.name, systemImage: item.icon)
                    }
                }
            } label: {
                valueLabel(light)
            }
        }
        .padding(.vertical, 10)
    }

    // Same look for every row value: text + arrows, aligned to the right edge
    private func valueLabel(_ text: String) -> some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.rowText)
                .tracking(-0.46)
            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(Color.secondaryValue)
    }
}

#Preview { SetReminderView() }
