import SwiftUI

enum EETStep: Int, CaseIterable, Identifiable {
    case group        // Green   — what kind is it?
    case does_        // Blue    — what does it do?
    case looks        // Eye     — what does it look like?
    case covered      // Brown   — what is it covered with?
    case parts        // Pink    — what are its parts?
    case lives        // White   — where does it live?
    case funFact      // Gray ?  — what else do I know?

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .group:    return "Group"
        case .does_:    return "Does"
        case .looks:    return "Looks Like"
        case .covered:  return "Covered With"
        case .parts:    return "Parts"
        case .lives:    return "Lives"
        case .funFact:  return "Fun Fact"
        }
    }

    var prompt: String {
        switch self {
        case .group:    return "What kind of animal is it?"
        case .does_:    return "What does it do?"
        case .looks:    return "What does it look like?"
        case .covered:  return "What is its body covered with?"
        case .parts:    return "What are its parts?"
        case .lives:    return "Where does it live?"
        case .funFact:  return "What else do you know about it?"
        }
    }

    var color: Color {
        switch self {
        case .group:    return Color(red: 0.30, green: 0.78, blue: 0.40) // green
        case .does_:    return Color(red: 0.20, green: 0.55, blue: 0.95) // blue
        case .looks:    return Color(red: 0.95, green: 0.95, blue: 0.98) // eye (off-white)
        case .covered:  return Color(red: 0.58, green: 0.40, blue: 0.24) // wood/brown
        case .parts:    return Color(red: 0.97, green: 0.55, blue: 0.75) // pink
        case .lives:    return Color(red: 1.00, green: 1.00, blue: 1.00) // white
        case .funFact:  return Color(red: 0.55, green: 0.55, blue: 0.60) // gray
        }
    }

    /// SF Symbol shown on the bead for non-color cues (helps when colors are close).
    var glyph: String {
        switch self {
        case .group:    return "square.grid.2x2.fill"
        case .does_:    return "bolt.fill"
        case .looks:    return "eye.fill"
        case .covered:  return "scribble.variable"
        case .parts:    return "puzzlepiece.fill"
        case .lives:    return "house.fill"
        case .funFact:  return "questionmark"
        }
    }

    /// Sentence-builder prefix used when assembling the summary paragraph.
    func sentencePrefix(animalName: String) -> String {
        switch self {
        case .group:    return "\(animalName) is a"
        case .does_:    return "It"
        case .looks:    return "It looks"
        case .covered:  return "It is covered with"
        case .parts:    return "It has"
        case .lives:    return "It lives"
        case .funFact:  return "Did you know —"
        }
    }
}
