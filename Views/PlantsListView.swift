import SwiftUI

struct PlantsListView: View {
    // The view model owns the plants list and all the logic
    @State private var viewModel = PlantsViewModel()
    // Controls the "add plant" sheet
    @State private var showAdd = false
    // The plant the user tapped to edit (nil = no sheet)
    @State private var selectedPlant: Plant?

    var body: some View {
        ZStack {
            // Layer 1: black background
            Color.black.ignoresSafeArea()

            // Layer 2: title, divider, and content
            VStack(alignment: .leading, spacing: 0) {
                Text("My Plants 🌱")
                    .font(.screenTitle)
                    .tracking(0.37)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Divider()
                    .overlay(Color.white.opacity(0.3))
                    .padding(.top, 8)
                    .padding(.leading)

                // The screen follows the data: empty, all done, or list
                if viewModel.plants.isEmpty {
                    emptyView
                } else if viewModel.allDone {
                    doneView
                } else {
                    listView
                }
            }

            // Layer 3: floating + button
            addButton
        }
        .preferredColorScheme(.dark)
        // Sheet for adding a new plant
        .sheet(isPresented: $showAdd) {
            SetReminderView(onSave: viewModel.add)
        }
        // Sheet for editing or deleting an existing plant
        .sheet(item: $selectedPlant) { plant in
            SetReminderView(
                plantToEdit: plant,
                onSave: viewModel.update,
                onDelete: { viewModel.delete(plant) }
            )
        }
    }

    // MARK: - States

    // Shown when there are no plants yet
    private var emptyView: some View {
        VStack {
            Spacer()
            Text("No reminders set yet..")
                .font(.emptyTitle)
                .foregroundStyle(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // Shown when every plant has been watered
    private var doneView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image("plantDone")
                .resizable().scaledToFit()
                .frame(width: 200, height: 200)
            Text("All Done! 🎉")
                .font(.heading)
                .foregroundStyle(.white)
            Text("All Reminders Completed")
                .font(.footnote)
                .foregroundStyle(.gray)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // Shown when there are plants that still need water
    private var listView: some View {
        VStack(spacing: 0) {
            // Status message that changes with progress
            Text(viewModel.statusMessage)
                .font(.rowText)
                .tracking(0.23)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 36)

            // Custom progress bar
            progressBar
                .padding(.horizontal, 24)
                .padding(.top, 8)

            // List is used so swipe-to-delete works
            List {
                // Pending plants first, watered plants last
                ForEach(viewModel.sortedPlants) { plant in
                    PlantRow(plant: plant, onToggle: { viewModel.toggleWatered(plant) })
                        .contentShape(Rectangle())
                        // Tapping the row opens the edit sheet
                        .onTapGesture { selectedPlant = plant }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.black)
                        .listRowSeparatorTint(Color.white.opacity(0.15))
                        // Make the separator span the full row width
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        .alignmentGuide(.listRowSeparatorTrailing) { d in d.width }
                        // Swipe from the right to reveal the delete button
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.delete(plant)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.top, 20)
        }
    }

    // Custom progress bar: thicker, rounded, and colored like the design
    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track (background)
                Capsule()
                    .fill(Color.white.opacity(0.15))

                // Fill (the watered part)
                Capsule()
                    .fill(Color.plantProgress)
                    .frame(width: geo.size.width * viewModel.progress)
                    .animation(.easeInOut, value: viewModel.progress)
            }
        }
        .frame(height: 10)
    }

    // Floating + button with a glass-style look in the bottom-right corner
    private var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button { showAdd = true } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background {
                            ZStack {
                                Circle().fill(Color.plantButton)
                                // Soft light from the top-left (glass shine)
                                Circle().fill(
                                    RadialGradient(
                                        colors: [Color.white.opacity(0.18), Color.white.opacity(0.0)],
                                        center: .topLeading,
                                        startRadius: 0,
                                        endRadius: 56
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
        }
        .padding()
    }
}

#Preview { PlantsListView() }
