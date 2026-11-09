import SwiftUI

struct PlantRow: View {
    // The plant this row displays (passed in from the list)
    let plant: Plant
    // Called when the user taps the circle; the view model toggles the state
    var onToggle: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {

            // Completion button: empty circle, or mint checkmark when watered
            Button(action: onToggle) {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(plant.isWatered ? Color.plantMint : .gray)
            }
            // Keeps the circle tap separate from the row tap inside a List
            .buttonStyle(.plain)

            // Plant information
            VStack(alignment: .leading, spacing: 6) {

                // Room: location icon + text, close together
                HStack(spacing: 4) {
                    Image(systemName: "location")
                    Text("in \(plant.room)")
                }
                .font(.smallText)
                .foregroundStyle(.gray)

                // Plant name: 28 regular (dimmed once watered)
                Text(plant.name)
                    .font(.plantName)
                    .tracking(0.36)
                    .foregroundStyle(plant.isWatered ? .gray : .white)

                // Light and water tags
                HStack(spacing: 8) {
                    tag("sun.max", plant.light)
                    tag("drop", plant.water)
                }
            }

            // Pushes everything to the left
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }

    // Reusable tag: icon + text inside a rounded background
    private func tag(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.smallText)
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(white: 0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// Preview with one pending plant and one watered plant
#Preview {
    VStack(spacing: 0) {
        PlantRow(plant: Plant(name: "Monstera", room: "Kitchen", light: "Full Sun", water: "20-50 ml"))
        PlantRow(plant: Plant(name: "Pothos", room: "Bedroom", light: "Full Sun", water: "20-50 ml", isWatered: true))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
}
