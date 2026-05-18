import SwiftUI
import AVFoundation

struct SummaryView: View {
    let animal: Animal
    let selections: [EETStep: String]
    let onDone: () -> Void

    @Environment(\.dismiss) private var dismiss
    private let speaker = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(animal.emoji).font(.system(size: 100))
                    Text("Great job!")
                        .font(.system(.title, design: .rounded).weight(.heavy))
                    Text("Here's everything you said about a \(animal.name.lowercased()):")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)
                .padding(.horizontal)

                // Per-bead recap
                VStack(spacing: 10) {
                    ForEach(EETStep.allCases) { step in
                        BeadRecapRow(step: step,
                                     answer: selections[step] ?? "")
                    }
                }
                .padding(.horizontal)

                // Full paragraph
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your full description")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(paragraph)
                        .font(.system(.title3, design: .rounded))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button(action: speak) {
                        Label("Read it out loud", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue, in: Capsule())
                            .foregroundColor(.white)
                    }

                    Button(action: onDone) {
                        Label("Done", systemImage: "checkmark")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.green, in: Capsule())
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var paragraph: String {
        EETStep.allCases.compactMap { step -> String? in
            guard let answer = selections[step], !answer.isEmpty else { return nil }
            let prefix = step.sentencePrefix(animalName: animal.name)
            return "\(prefix) \(answer)."
        }.joined(separator: " ")
    }

    private func speak() {
        if speaker.isSpeaking { speaker.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: paragraph)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.46
        speaker.speak(utterance)
    }
}

private struct BeadRecapRow: View {
    let step: EETStep
    let answer: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(step.color)
                Image(systemName: step.glyph)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(step == .looks || step == .lives
                                     ? .black.opacity(0.7) : .white)
            }
            .frame(width: 36, height: 36)
            .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(answer.isEmpty ? "—" : answer.capitalizingFirstLetter())
                    .font(.system(.body, design: .rounded))
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

private extension String {
    func capitalizingFirstLetter() -> String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst()
    }
}

#Preview {
    let animal = AnimalLibrary.elephant
    var selections: [EETStep: String] = [:]
    for step in EETStep.allCases {
        selections[step] = animal.correctAnswer(for: step)
    }
    return NavigationStack {
        SummaryView(animal: animal, selections: selections, onDone: {})
    }
}
