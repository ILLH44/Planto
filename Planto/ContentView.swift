import SwiftUI

struct ContentView: View {
    // For testing: starts from the onboarding screen on every launch
    @State private var hasSeenOnboarding = false

    // Before submitting: replace the line above with this one
    // so the app remembers that the user has seen the onboarding
    // @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        // Decide which screen to show based on the saved state
        if hasSeenOnboarding {
            PlantsListView()
        } else {
            OnboardingView(onFinish: { hasSeenOnboarding = true })
        }
    }
}

#Preview { ContentView()
}


