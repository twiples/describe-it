import Foundation

struct Choice: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

struct Animal: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    private let answers: [EETStep: [Choice]]

    init(name: String, emoji: String, answers: [EETStep: [Choice]]) {
        self.name = name
        self.emoji = emoji
        self.answers = answers
    }

    func choices(for step: EETStep) -> [Choice] {
        answers[step] ?? []
    }

    func correctAnswer(for step: EETStep) -> String {
        answers[step]?.first(where: { $0.isCorrect })?.text ?? ""
    }

    static func == (lhs: Animal, rhs: Animal) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
