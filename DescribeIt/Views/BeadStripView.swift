import SwiftUI

struct BeadStripView: View {
    let currentIndex: Int
    let completedSteps: Set<EETStep>

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // String running through the beads.
                Rectangle()
                    .fill(Color.gray.opacity(0.35))
                    .frame(height: 3)
                    .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    ForEach(EETStep.allCases) { step in
                        Bead(step: step,
                             isCurrent: step.rawValue == currentIndex,
                             isCompleted: completedSteps.contains(step))
                    }
                }
            }
            .frame(width: proxy.size.width)
        }
        .frame(height: 64)
    }
}

private struct Bead: View {
    let step: EETStep
    let isCurrent: Bool
    let isCompleted: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(step.color)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: isCurrent ? step.color.opacity(0.6) : .clear,
                        radius: isCurrent ? 10 : 0)

            Image(systemName: isCompleted ? "checkmark" : step.glyph)
                .font(.system(size: isCurrent ? 18 : 14, weight: .bold))
                .foregroundColor(symbolColor)
        }
        .frame(width: isCurrent ? 48 : 36, height: isCurrent ? 48 : 36)
        .opacity(isCurrent || isCompleted ? 1.0 : 0.55)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isCurrent)
    }

    private var symbolColor: Color {
        // Light beads (looks/lives) need a dark glyph for contrast.
        switch step {
        case .looks, .lives: return .black.opacity(0.7)
        default:             return .white
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        BeadStripView(currentIndex: 0, completedSteps: [])
        BeadStripView(currentIndex: 3, completedSteps: [.group, .does_, .looks])
        BeadStripView(currentIndex: 6, completedSteps: Set(EETStep.allCases.dropLast()))
    }
    .padding()
}
