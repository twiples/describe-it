import SwiftUI

struct SessionView: View {
    let animal: Animal

    @Environment(\.dismiss) private var dismiss
    @State private var stepIndex: Int = 0
    @State private var selections: [EETStep: String] = [:]
    @State private var tappedChoice: Choice?
    @State private var showingSummary = false

    private var currentStep: EETStep { EETStep.allCases[stepIndex] }
    private var completed: Set<EETStep> { Set(selections.keys) }

    var body: some View {
        VStack(spacing: 16) {
            BeadStripView(currentIndex: stepIndex, completedSteps: completed)
                .padding(.top, 8)

            animalHeader

            PromptCard(step: currentStep, animalName: animal.name)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(animal.choices(for: currentStep)) { choice in
                    ChoiceButton(
                        choice: choice,
                        state: choiceState(for: choice),
                        action: { handleTap(choice) }
                    )
                }
            }
            .padding(.horizontal)

            Spacer(minLength: 0)
        }
        .background(
            currentStep.color.opacity(0.10).ignoresSafeArea()
        )
        .animation(.easeInOut(duration: 0.25), value: stepIndex)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") { dismiss() }
            }
        }
        .navigationDestination(isPresented: $showingSummary) {
            SummaryView(animal: animal, selections: selections) {
                showingSummary = false
                dismiss()
            }
        }
    }

    private var animalHeader: some View {
        HStack(spacing: 12) {
            Text(animal.emoji).font(.system(size: 56))
            Text(animal.name)
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
            Spacer()
        }
        .padding(.horizontal)
    }

    private func choiceState(for choice: Choice) -> ChoiceButton.State {
        guard let tapped = tappedChoice else { return .idle }
        if choice.id == tapped.id {
            return tapped.isCorrect ? .correct : .wrong
        }
        // After a correct tap, dim the others.
        if tapped.isCorrect { return .dimmed }
        return .idle
    }

    private func handleTap(_ choice: Choice) {
        // If already moving on or this was the correct one, ignore.
        if let tapped = tappedChoice, tapped.isCorrect { return }
        tappedChoice = choice

        if choice.isCorrect {
            selections[currentStep] = choice.text
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                advance()
            }
        } else {
            // Allow them to try again after a brief beat.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                tappedChoice = nil
            }
        }
    }

    private func advance() {
        tappedChoice = nil
        if stepIndex + 1 < EETStep.allCases.count {
            stepIndex += 1
        } else {
            showingSummary = true
        }
    }
}

// MARK: - Prompt Card

private struct PromptCard: View {
    let step: EETStep
    let animalName: String

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle().fill(step.color)
                Image(systemName: step.glyph)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(step == .looks || step == .lives
                                     ? .black.opacity(0.7) : .white)
            }
            .frame(width: 56, height: 56)
            .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(step.title.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(step.prompt)
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        )
    }
}

// MARK: - Choice Button

struct ChoiceButton: View {
    enum State { case idle, correct, wrong, dimmed }

    let choice: Choice
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(choice.text)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .opacity(state == .dimmed ? 0.4 : 1.0)
            .scaleEffect(state == .correct ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
        }
        .buttonStyle(.plain)
        .disabled(state == .correct || state == .dimmed)
    }

    private var background: Color {
        switch state {
        case .idle, .dimmed: return Color(.secondarySystemBackground)
        case .correct:       return Color(red: 0.30, green: 0.78, blue: 0.40)
        case .wrong:         return Color(red: 0.95, green: 0.40, blue: 0.40)
        }
    }

    private var textColor: Color {
        switch state {
        case .idle, .dimmed: return .primary
        case .correct, .wrong: return .white
        }
    }
}

#Preview {
    NavigationStack {
        SessionView(animal: AnimalLibrary.elephant)
    }
}
