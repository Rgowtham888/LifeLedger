import Foundation

enum TrackerDataType: String, CaseIterable {
    case number
    case text
}

enum TrackerInputType: String, CaseIterable {
    case incrementor
    case checkbox
    case text
}

struct TrackerField: Identifiable {
    let key: String
    let displayValue: String
    let dataType: TrackerDataType
    let inputType: TrackerInputType
    let range: ClosedRange<Int>?
    let defaultNumber: Int

    var id: String { key }

    static func incrementor(
        _ key: String,
        displayValue: String,
        range: ClosedRange<Int>,
        defaultNumber: Int = 0
    ) -> TrackerField {
        TrackerField(
            key: key,
            displayValue: displayValue,
            dataType: .number,
            inputType: .incrementor,
            range: range,
            defaultNumber: defaultNumber
        )
    }

    static func checkbox(_ key: String, displayValue: String) -> TrackerField {
        TrackerField(
            key: key,
            displayValue: displayValue,
            dataType: .number,
            inputType: .checkbox,
            range: 0...1,
            defaultNumber: 0
        )
    }

    static func text(_ key: String, displayValue: String) -> TrackerField {
        TrackerField(
            key: key,
            displayValue: displayValue,
            dataType: .text,
            inputType: .text,
            range: nil,
            defaultNumber: 0
        )
    }
}

// Edit this single array to reorder/add/remove tracker inputs.
enum TrackerFieldCatalog {
    static let fields: [TrackerField] = [
        .incrementor(TrackerFieldKeys.sleepQuality, displayValue: "Sleep Quality", range: 0...10, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.addedSugar, displayValue: "Added Sugar", range: 0...10, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.focusQuality, displayValue: "Focus Quality", range: 1...5, defaultNumber: 3),
        .incrementor(TrackerFieldKeys.energyLevel, displayValue: "Energy Level", range: 1...5, defaultNumber: 3),
        .incrementor(TrackerFieldKeys.mood, displayValue: "Mood", range: 1...5, defaultNumber: 3),
        .incrementor(TrackerFieldKeys.proteinGrams, displayValue: "Protein (g)", range: 0...300, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.junkMeal, displayValue: "Junk Meal", range: 0...5, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.acidReflux, displayValue: "Acid Reflux", range: 0...5, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.headache, displayValue: "Headache", range: 0...5, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.patienceLevel, displayValue: "Patience Level", range: 1...5, defaultNumber: 3),
        .incrementor(TrackerFieldKeys.eggs, displayValue: "Eggs", range: 0...12, defaultNumber: 0),
        .incrementor(TrackerFieldKeys.connectionFelt, displayValue: "Connection Felt", range: 0...3, defaultNumber: 0),

        .checkbox(TrackerFieldKeys.gym, displayValue: "Gym"),
        .checkbox(TrackerFieldKeys.back, displayValue: "Back"),
        .checkbox(TrackerFieldKeys.legs, displayValue: "Legs"),
        .checkbox(TrackerFieldKeys.shoulders, displayValue: "Shoulders"),
        .checkbox(TrackerFieldKeys.chest, displayValue: "Chest"),
        .checkbox(TrackerFieldKeys.biceps, displayValue: "Biceps"),
        .checkbox(TrackerFieldKeys.triceps, displayValue: "Triceps"),
        .checkbox(TrackerFieldKeys.forearmsGrip, displayValue: "Forearms / Grip Used"),
        .checkbox(TrackerFieldKeys.core, displayValue: "Core Trained"),
        .checkbox(TrackerFieldKeys.lateEating, displayValue: "Late Eating"),
        .checkbox(TrackerFieldKeys.hydrationOK, displayValue: "Hydration OK"),
        .checkbox(TrackerFieldKeys.chicken, displayValue: "Chicken"),
        .checkbox(TrackerFieldKeys.otherMeat, displayValue: "Other Meat (Fish/Mutton)"),
        .checkbox(TrackerFieldKeys.mentalClarity, displayValue: "Mental Clarity"),
        .checkbox(TrackerFieldKeys.anxietyOverthinking, displayValue: "Anxiety / Overthinking"),
        .checkbox(TrackerFieldKeys.learnedSomething, displayValue: "Learned Something"),
        .checkbox(TrackerFieldKeys.readingDone, displayValue: "Reading Done"),
        .checkbox(TrackerFieldKeys.meditationStillness, displayValue: "Meditation / Stillness"),
        .checkbox(TrackerFieldKeys.deepWork, displayValue: "Deep Work"),
        .checkbox(TrackerFieldKeys.primaryThemeSlotUsed, displayValue: "Primary Theme Slot Used"),
        .checkbox(TrackerFieldKeys.themeFollowed, displayValue: "Theme Followed"),
        .checkbox(TrackerFieldKeys.familyTime, displayValue: "Family Time Present"),
        .checkbox(TrackerFieldKeys.aloneTime, displayValue: "Alone Time"),
        .checkbox(TrackerFieldKeys.selfCareDone, displayValue: "Self-Care Done"),
        .checkbox(TrackerFieldKeys.socialInteraction, displayValue: "Social Interaction"),
        .checkbox(TrackerFieldKeys.feltCalm, displayValue: "Felt Calm"),
        .checkbox(TrackerFieldKeys.cardioStepsMovement, displayValue: "Cardio / Steps / Movement"),
        .checkbox(TrackerFieldKeys.daytimeSleepy, displayValue: "Sleepy During Day"),
        .checkbox(TrackerFieldKeys.digestionOK, displayValue: "Digestion OK"),
        .checkbox(TrackerFieldKeys.painDiscomfort, displayValue: "Pain / Discomfort"),

        .text(TrackerFieldKeys.currentTheme, displayValue: "Current Theme"),
        .text(TrackerFieldKeys.dailyNotes, displayValue: "Daily Notes")
    ]
}

enum TrackerFieldKeys {
    static let sleepQuality = "sleep_quality"
    static let digestionOK = "digestion_ok"
    static let painDiscomfort = "pain_discomfort"
    static let acidReflux = "acid_reflux"
    static let headache = "headache"
    static let daytimeSleepy = "daytime_sleepy"
    static let energyLevel = "energy_level"

    static let gym = "gym"
    static let back = "back"
    static let legs = "legs"
    static let shoulders = "shoulders"
    static let chest = "chest"
    static let biceps = "biceps"
    static let triceps = "triceps"
    static let forearmsGrip = "forearms_grip"
    static let core = "core"

    static let addedSugar = "added_sugar"
    static let junkMeal = "junk_meal"
    static let lateEating = "late_eating"
    static let hydrationOK = "hydration_ok"

    static let proteinGrams = "protein_grams"
    static let chicken = "chicken"
    static let eggs = "eggs"
    static let otherMeat = "other_meat"

    static let mentalClarity = "mental_clarity"
    static let anxietyOverthinking = "anxiety_overthinking"
    static let learnedSomething = "learned_something"
    static let readingDone = "reading_done"
    static let meditationStillness = "meditation_stillness"
    static let deepWork = "deep_work"
    static let focusQuality = "focus_quality"

    static let currentTheme = "current_theme"
    static let primaryThemeSlotUsed = "primary_theme_slot_used"
    static let themeFollowed = "theme_followed"

    static let familyTime = "family_time"
    static let connectionFelt = "connection_felt"
    static let aloneTime = "alone_time"
    static let selfCareDone = "self_care_done"
    static let socialInteraction = "social_interaction"
    static let patienceLevel = "patience_level"

    static let feltCalm = "felt_calm"
    static let mood = "mood"
    static let dailyNotes = "daily_notes"

    static let cardioStepsMovement = "cardio_steps_movement"
}
