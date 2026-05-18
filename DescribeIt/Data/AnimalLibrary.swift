import Foundation

enum AnimalLibrary {
    static let all: [Animal] = [
        elephant, penguin, octopus, lion, frog, eagle, shark, snake
    ]

    private static func make(
        _ name: String,
        _ emoji: String,
        group: (String, String, String),
        does: (String, String, String),
        looks: (String, String, String),
        covered: (String, String, String),
        parts: (String, String, String),
        lives: (String, String, String),
        funFact: (String, String, String)
    ) -> Animal {
        func choices(_ trio: (String, String, String)) -> [Choice] {
            [
                Choice(text: trio.0, isCorrect: true),
                Choice(text: trio.1, isCorrect: false),
                Choice(text: trio.2, isCorrect: false)
            ].shuffled()
        }
        return Animal(
            name: name,
            emoji: emoji,
            answers: [
                .group:   choices(group),
                .does_:   choices(does),
                .looks:   choices(looks),
                .covered: choices(covered),
                .parts:   choices(parts),
                .lives:   choices(lives),
                .funFact: choices(funFact)
            ]
        )
    }

    static let elephant = make(
        "Elephant", "🐘",
        group:   ("a mammal", "a bird", "a fish"),
        does:    ("eats plants and trumpets with its trunk",
                  "hunts mice at night",
                  "lays eggs in the sand"),
        looks:   ("big and gray with a long trunk",
                  "tiny and yellow with stripes",
                  "slimy and green"),
        covered: ("tough gray skin", "soft feathers", "hard shiny scales"),
        parts:   ("a trunk, tusks, big ears, and four legs",
                  "wings, a beak, and two legs",
                  "eight arms and suckers"),
        lives:   ("on the savannas of Africa and Asia",
                  "deep in the ocean",
                  "in a snowy forest"),
        funFact: ("an elephant's trunk has over 40,000 muscles",
                  "elephants can fly across oceans",
                  "elephants change color in winter")
    )

    static let penguin = make(
        "Penguin", "🐧",
        group:   ("a bird", "a mammal", "a fish"),
        does:    ("waddles on land and swims in the sea",
                  "climbs tall trees",
                  "builds webs to catch flies"),
        looks:   ("black and white with a round belly",
                  "big and orange with stripes",
                  "long and green with scales"),
        covered: ("waterproof feathers", "soft fur", "slimy skin"),
        parts:   ("a beak, wings, and webbed feet",
                  "a trunk, tusks, and four legs",
                  "eight long arms"),
        lives:   ("on icy shores in Antarctica",
                  "in a hot desert",
                  "high in a leafy jungle"),
        funFact: ("penguins can't fly but they swim very fast",
                  "penguins sleep upside down in caves",
                  "penguins have venom in their tails")
    )

    static let octopus = make(
        "Octopus", "🐙",
        group:   ("a sea animal (invertebrate)", "a mammal", "a reptile"),
        does:    ("swims and squirts ink to escape",
                  "howls at the moon",
                  "builds webs in trees"),
        looks:   ("squishy with a big head and long arms",
                  "furry with four legs",
                  "bumpy with hard armor"),
        covered: ("soft, slimy skin", "fluffy fur", "a bony shell"),
        parts:   ("a head, eight arms, and suckers",
                  "a trunk and tusks",
                  "wings and a beak"),
        lives:   ("in the ocean",
                  "high in the mountains",
                  "in a snowy forest"),
        funFact: ("an octopus has three hearts and blue blood",
                  "an octopus lays 1,000 eggs in a tree",
                  "an octopus hibernates all summer")
    )

    static let lion = make(
        "Lion", "🦁",
        group:   ("a mammal", "a bird", "an amphibian"),
        does:    ("hunts in groups and roars very loud",
                  "lays eggs on the beach",
                  "sleeps in honeycombs"),
        looks:   ("big and golden with a fluffy mane",
                  "tiny and pink with wings",
                  "long and silver with fins"),
        covered: ("tan fur", "sticky webs", "smooth scales"),
        parts:   ("four legs, paws, a tail, and a mane",
                  "wings and a beak",
                  "eight arms and suckers"),
        lives:   ("on the grasslands of Africa",
                  "at the bottom of the ocean",
                  "on icebergs"),
        funFact: ("a lion's roar can be heard from 5 miles away",
                  "lions can breathe fire",
                  "lions change color when they get scared")
    )

    static let frog = make(
        "Frog", "🐸",
        group:   ("an amphibian", "a fish", "a bird"),
        does:    ("hops and catches bugs with its long tongue",
                  "builds nests in tall trees",
                  "hunts seals on the ice"),
        looks:   ("small and green with big eyes",
                  "huge and gray with a trunk",
                  "furry and orange with stripes"),
        covered: ("smooth, damp skin", "thick fur", "hard scales"),
        parts:   ("four legs, a long tongue, and big eyes",
                  "a trunk and tusks",
                  "wings and a beak"),
        lives:   ("near ponds and streams",
                  "in a hot dry desert",
                  "at the top of a mountain"),
        funFact: ("frogs can breathe through their skin",
                  "frogs lay eggs in the clouds",
                  "frogs sleep upside down in caves")
    )

    static let eagle = make(
        "Eagle", "🦅",
        group:   ("a bird", "a reptile", "a mammal"),
        does:    ("flies high and hunts with sharp claws",
                  "swims deep in the ocean",
                  "hops from lily pad to lily pad"),
        looks:   ("big, with brown feathers and a white head",
                  "squishy with eight arms",
                  "pink with a long trunk"),
        covered: ("feathers", "slimy skin", "fluffy wool"),
        parts:   ("wings, a beak, talons, and tail feathers",
                  "a trunk and tusks",
                  "fins and gills"),
        lives:   ("in tall trees and on mountain cliffs",
                  "deep under the sea",
                  "under the snow"),
        funFact: ("eagles can spot prey from a mile away",
                  "eagles sleep in beehives",
                  "eagles change color every winter")
    )

    static let shark = make(
        "Shark", "🦈",
        group:   ("a fish", "a mammal", "a bird"),
        does:    ("swims fast and hunts in the ocean",
                  "climbs tall trees",
                  "flies south for the winter"),
        looks:   ("long and gray with sharp teeth",
                  "small and pink with wings",
                  "round and fluffy with little ears"),
        covered: ("tough skin and tiny scales", "soft feathers", "thick fur"),
        parts:   ("fins, gills, a tail, and sharp teeth",
                  "wings and a beak",
                  "a trunk and tusks"),
        lives:   ("in the ocean",
                  "on a snowy mountain",
                  "in a leafy jungle tree"),
        funFact: ("a shark can grow thousands of teeth in its lifetime",
                  "sharks sing songs to the moon",
                  "sharks hibernate all summer long")
    )

    static let snake = make(
        "Snake", "🐍",
        group:   ("a reptile", "a mammal", "a bird"),
        does:    ("slithers along the ground and flicks its tongue",
                  "builds dams in rivers",
                  "flies south for the winter"),
        looks:   ("long and skinny with no legs",
                  "big and round with horns",
                  "fluffy with a striped tail"),
        covered: ("smooth, dry scales", "wet fur", "soft feathers"),
        parts:   ("a head, a long body, a tongue, and a tail",
                  "wings and a beak",
                  "four legs and paws"),
        lives:   ("in forests, deserts, and grasslands",
                  "on icebergs",
                  "deep in the ocean"),
        funFact: ("snakes smell with their tongues",
                  "snakes sleep in beehives",
                  "snakes lay their eggs in clouds")
    )
}
