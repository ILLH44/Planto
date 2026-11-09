import SwiftUI

struct OnboardingView: View {
    // Called when the user taps the button; the parent decides what happens next
    var onFinish: () -> Void = {}

    var body: some View {
        ZStack {
            // Layer 1: black background
            Color.black.ignoresSafeArea()

            // Layer 2: title, divider, image, texts, and button
            VStack(alignment: .leading, spacing: 0) {
                Text("My Plants 🌱")
                    .font(.screenTitle)
                    .tracking(0.37)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Thin divider under the title
                Divider()
                    .overlay(Color.white.opacity(0.3))
                    .padding(.top, 8)
                    .padding(.leading)

                // Pushes the content toward the center
                Spacer()

                // Plant image
                Image("plant")
                    .resizable().scaledToFit()
                    .frame(width: 230, height: 230)
                    .frame(maxWidth: .infinity)

                // Main heading: 22 semibold
                Text("Start your plant journey!")
                    .font(.heading)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                // Gray subtitle: 14 regular
                Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                    .font(.bodyText)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                // Green capsule button that triggers onFinish
                Button(action: onFinish) {
                    Text("Set Plant Reminder")
                        .font(.buttonText)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.plantButton)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 80)
                .padding(.top, 90)

                // Two bottom spacers push the content slightly above center
                Spacer()
                Spacer()
            }
        }
        // Force dark mode to match the design
        .preferredColorScheme(.dark)
    }
}

#Preview { OnboardingView() }
