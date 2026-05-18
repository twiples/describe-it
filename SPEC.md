# Describe It! — Product Spec

> A multi-modal web app that helps a child expand their expressive language using the **Expanding Expression Tool (EET)** method. The child *produces* descriptions of objects/things — speaking, typing, or drawing them — rather than picking from choices.

---

## 1. Who this is for

- **Primary user:** a young child (early reader) working on expressive language — turning ideas into full descriptions and sentences about concrete things.
- **Secondary user:** the parent / therapist who sets up sessions, reviews answers, and shares progress.

The goal is **language expansion**, not vocabulary testing. The win condition is the child *producing* more language per session, not picking correct labels.

---

## 2. The EET method (what we're implementing)

Based on the Expanding Expression Tool — a multisensory bead-strand approach where a child describes an object by stepping through 7 colored beads, each prompting a different category of detail. Reference: https://www.expandingexpression.com/

| # | Bead | Color | Prompt |
|---|------|-------|--------|
| 1 | Group | Green | What kind is it? |
| 2 | Does | Blue | What does it do? |
| 3 | Looks | Eye / off-white | What does it look like? |
| 4 | Covered with | Brown (wood) | What's it covered with / made of? |
| 5 | Parts | Pink | What are its parts? |
| 6 | Lives | White | Where is it / where does it live? |
| 7 | Fun fact | Gray with ? | What else do you know? |

At the end, the child's seven answers assemble into a **paragraph** describing the thing.

---

## 3. Design principles

1. **Production over recognition.** The child forms their own words. The app gives scaffolding and prompts, not multiple-choice answers.
2. **Object/concept scope only.** EET is canonically a noun-describer. The app deliberately *doesn't* try to capture event recounts ("my day at school") — that's a different framework (Story Grammar Marker / Braidy) and a different product.
3. **No "wrong" answers.** EET is expansion, not assessment. The app affirms effort, doesn't grade content. Parent/SLP review happens out-of-band.
4. **Subject is open-ended.** The child picks anything to describe — an animal, a toy, a food, a vehicle. The app figures out the subject from speech and lights beads as descriptive categories get covered.
5. **Single device, on-device.** No accounts, no cloud, no analytics in v1. Audio and drawings stay on device. Parent-friendly privacy.
6. **Kid-readable UI.** Big rounded buttons, generous spacing, emoji-scale visuals. Text supports — doesn't replace — the icons.

---

## 4. v1 scope (current prototype)

### What it does today
- Single-screen "talk" interface — no animal picker, no per-bead step-through.
- Big mic + auto-restart speech recognition.
- **Subject detection** — `~120-word` vocabulary across animals, vehicles, food, plants, places, toys, instruments. The most-mentioned matching word wins, with shimmer-animated subject card.
- **Explicit subject capture** — phrases like *"I want to talk about ___"*, *"let me tell you about ___"*, *"today let's talk about ___"* extract and **lock** the subject (won't be overridden by stray nouns).
- **EET classifier** — keyword + regex patterns per bead. Each category fires when the child's speech hits it; bead pops, chimes, and the triggering phrase is shown beside the bead label for parent transparency.
- **Hints** — tap any unlit bead to see its prompt; "Need a hint?" surfaces the first unlit one.
- **Summary view** — recap by bead with matched phrases highlighted, full transcript, and a "Read it back" button using `speechSynthesis`.

### Out of scope for v1
- Multiple capture modalities (audio recording, typing, drawing) — initially considered, parked for later. Speech-first is the simplest path to validate EET-via-speech.
- User accounts / multi-child profiles
- Cloud sync, export to email/Drive, sharing
- Parent dashboard / progress tracking over time
- Word library editor (parent-authored subjects)
- Reward/sticker system
- Real photographs (emoji only)
- Therapy assessment / scoring

### Explicitly *not* doing
- Grading "correctness." EET is not a quiz.
- Capturing event recounts / "my day" / story narration — wrong framework. If we ever want that, layer in a separate Story Grammar Marker-style mode as a *separate* product, not bolted to this one.
- Forcing all 7 beads. The child can stop anytime; un-covered beads show as ghost rows in the summary.

---

## 5. User flow

```
┌──────────────────────────────────────┐
│  Open app                            │
│  → Big mic + "Come up with something │
│    you want to tell me about!"       │
│  → Tap mic (first time prompts for   │
│    mic permission)                   │
│  → Child talks freely                │
│  → Subject card resolves with emoji  │
│  → Beads light up as EET categories  │
│    are covered, with chime + phrase  │
│  → "All done →" anytime              │
│  → Summary: bead-by-bead recap +     │
│    full transcript + read-aloud      │
└──────────────────────────────────────┘
```

---

## 6. Architecture (current prototype)

Single-file `prototype.html`, no build step. State machine + DOM updates in plain JS. Speech recognition via `webkitSpeechRecognition` (Web Speech API). Speech synthesis via `speechSynthesis`. Tiny chime via `AudioContext` oscillator on each bead light.

```
state {
  finalText, interimText         // accumulating transcript
  lit                            // beadKey → { phrase, sentence }
  subject, subjectVotes          // resolved subject + voting
  subjectLocked                  // true if explicit "talk about X" fired
  listening, shouldKeepListening // mic state
}

consumeNewFinal(chunk) →
  for each sentence:
    updateSubject(s)    // explicit-intro OR vocab vote
    classify(s)         // run keyword/regex against unlit beads
    lightBead(...)      // pop, chime, render
```

Persistence: none in v1. State resets on reload.

---

## 7. Data: subject vocab and EET classifier

**SUBJECTS** dictionary (~120 entries) maps lowercased nouns → `{canonical, emoji}`. Multi-word matches (`"fire truck"`) tried before single-word (`"truck"`). Plurals and common variants enumerated.

**CLASSIFIER** has 7 keys (one per bead). Each has:
- `keywords`: array of trigger words (word-boundary matched, case-insensitive)
- `phrases`: array of regex patterns

The Fun Fact bead has a fallback rule: if a sentence is substantive (≥4 words) but didn't match any other bead, it counts as a fun fact. This rewards the child for adding info we don't have a category for.

---

## 8. Known limitations

1. **Speech recognition accuracy on children's voices.** Web Speech API is tuned on adult voices. Articulation differences in young children — *especially* children working on language expansion — make this worse. Mitigation: always show the live transcript so the child sees what's being heard; "Start over" is one tap.
2. **Browser support.** Web Speech API works reliably in Chrome and somewhat in Safari. Firefox doesn't support it. Hosted version should note Chrome as recommended.
3. **HTTPS requirement.** `getUserMedia` needs HTTPS. GitHub Pages serves HTTPS — fine for production. Local dev needs `http://localhost`.
4. **Subject vocab is finite.** "My hamster" or "a hovercraft" won't be recognized. The app handles this gracefully (beads still light from descriptive cues) but the subject card stays as 💭. Future: extend vocab, or swap to an LLM for free-form subject extraction.
5. **Classifier is heuristic.** Both false positives ("trunk" of a tree lighting Parts bead while talking about an elephant) and false negatives (a synonym not in the keyword list) happen. Tunable per-child.

---

## 9. Open questions

1. **Encouragement / affirmation.** Bead-pop + chime is gentle reinforcement. Worth more? Risk: rewards-on-completion could become the goal instead of the language.
2. **Hints/scaffolding when stuck.** Tap-bead-for-prompt works. Should the "Need a hint?" button speak the prompt aloud (currently text-only)?
3. **Parent review.** v1 leaves this to "open the app and look at the summary." v2 could persist sessions and offer a parent view across sessions.
4. **Custom subjects.** Should a parent be able to add custom items (a specific pet, a favorite stuffed animal) to the vocab?
5. **Multiple modalities.** Original plan included typing, audio recording, drawing. Parked. Worth revisiting after speech-first validation.

---

## 10. Future / parking lot

- Native iOS / SwiftUI wrapper (early scaffold exists in `DescribeIt/` Swift folder; pending Xcode install and product validation)
- Themes / topic packs (animals, vehicles, dinosaurs, household objects)
- Parent-authored subject vocab
- Session history with progress signals (avg # beads lit per session over time)
- Export session as a PDF "story"
- Localized prompts (other languages)
- Practice-one-bead mode (drill the same bead across many subjects)
- Optional drawing/audio modalities reintroduced for beads where verbal description is harder
