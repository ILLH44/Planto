import SwiftUI

struct ContentView: View {
    // Remembers that the user has already seen the onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

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
