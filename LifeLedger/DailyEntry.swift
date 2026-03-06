//
//  DailyEntry.swift
//  LifeLedger
//
//  Created by Gowtham on 08/02/26.
//


import Foundation
import SwiftData

@Model
final class DailyEntry {
    var date: Date

    // Body / Physiology
    var sleepQuality: Int
    var digestionOK: Bool
    var painDiscomfort: Bool
    var acidReflux: Int
    var headache: Int
    var daytimeSleepy: Bool
    var energyLevel: Int

    // Workout Tracker
    var gym: Bool
    var back: Bool
    var legs: Bool
    var shoulders: Bool
    var chest: Bool
    var biceps: Bool
    var triceps: Bool
    var forearmsGrip: Bool
    var core: Bool

    // Food / Recovery
    var addedSugar: Int
    var junkMeal: Int
    var lateEating: Bool
    var hydrationOK: Bool
    
    // Nutrient Tracker
    var proteinGrams: Int
    var chicken: Bool
    var eggs: Int
    var otherMeat: Bool

    // Mind / Cognition
    var mentalClarity: Bool
    var anxietyOverthinking: Bool
    var learnedSomething: Bool
    var readingDone: Bool
    var meditationStillness: Bool
    var deepWork: Bool
    var focusQuality: Int

    // Theme Execution
    var currentTheme: String
    var primaryThemeSlotUsed: Bool
    var themeFollowed: Bool

    // Relationship & Personal
    var familyTime: Bool
    var connectionFelt: Bool
    var aloneTime: Bool
    var selfCareDone: Bool
    var socialInteraction: Bool
    var patienceLevel: Int

    // Emotional State
    var feltCalm: Bool
    var mood: Int
    var dailyNotes: String

    // Movement
    var cardioStepsMovement: Bool

    // Dynamic store: only two persisted data types (Int + String)
    var numericValuesBlob: Data
    var textValuesBlob: Data
    var hasMigratedToDynamicStore: Bool

    init(date: Date = .now) {
        self.date = date

        self.sleepQuality = 0
        self.digestionOK = false
        self.painDiscomfort = false
        self.acidReflux = 0
        self.headache = 0
        self.daytimeSleepy = false
        self.energyLevel = 3

        self.gym = false
        self.back = false
        self.legs = false
        self.shoulders = false
        self.chest = false
        self.biceps = false
        self.triceps = false
        self.forearmsGrip = false
        self.core = false

        self.addedSugar = 0
        self.junkMeal = 0
        self.lateEating = false
        self.hydrationOK = false
        
        self.proteinGrams = 0
        self.chicken = false
        self.eggs = 0
        self.otherMeat = false

        self.mentalClarity = false
        self.anxietyOverthinking = false
        self.learnedSomething = false
        self.readingDone = false
        self.meditationStillness = false
        self.deepWork = false
        self.focusQuality = 3

        self.currentTheme = ""
        self.primaryThemeSlotUsed = false
        self.themeFollowed = false

        self.familyTime = false
        self.connectionFelt = false
        self.aloneTime = false
        self.selfCareDone = false
        self.socialInteraction = false
        self.patienceLevel = 3

        self.feltCalm = false
        self.mood = 3
        self.dailyNotes = ""

        self.cardioStepsMovement = false

        self.numericValuesBlob = Data("{}".utf8)
        self.textValuesBlob = Data("{}".utf8)
        self.hasMigratedToDynamicStore = false
    }
}

extension DailyEntry {
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs: date)
    }

    func intValue(for key: String, default defaultValue: Int = 0, legacy: (() -> Int)? = nil) -> Int {
        let values = decodeNumbers()
        if let value = values[key] {
            return value
        }
        if let legacy {
            return legacy()
        }
        return defaultValue
    }

    func setIntValue(_ value: Int, for key: String) {
        var values = decodeNumbers()
        values[key] = value
        numericValuesBlob = encode(values)
    }

    func textValue(for key: String, fallback: (() -> String)? = nil) -> String {
        let values = decodeTexts()
        if let value = values[key] {
            return value
        }
        if let fallback {
            return fallback()
        }
        return ""
    }

    func setTextValue(_ value: String, for key: String) {
        var values = decodeTexts()
        values[key] = value
        textValuesBlob = encode(values)
    }

    func applyLegacyMigrationIfNeeded() {
        guard !hasMigratedToDynamicStore else { return }

        // ints
        setIntValue(sleepQuality, for: TrackerFieldKeys.sleepQuality)
        setIntValue(acidReflux, for: TrackerFieldKeys.acidReflux)
        setIntValue(headache, for: TrackerFieldKeys.headache)
        setIntValue(energyLevel, for: TrackerFieldKeys.energyLevel)
        setIntValue(addedSugar, for: TrackerFieldKeys.addedSugar)
        setIntValue(junkMeal, for: TrackerFieldKeys.junkMeal)
        setIntValue(proteinGrams, for: TrackerFieldKeys.proteinGrams)
        setIntValue(eggs, for: TrackerFieldKeys.eggs)
        setIntValue(focusQuality, for: TrackerFieldKeys.focusQuality)
        setIntValue(patienceLevel, for: TrackerFieldKeys.patienceLevel)
        setIntValue(mood, for: TrackerFieldKeys.mood)

        // booleans as 0/1 ints
        setIntValue(digestionOK ? 1 : 0, for: TrackerFieldKeys.digestionOK)
        setIntValue(painDiscomfort ? 1 : 0, for: TrackerFieldKeys.painDiscomfort)
        setIntValue(daytimeSleepy ? 1 : 0, for: TrackerFieldKeys.daytimeSleepy)
        setIntValue(gym ? 1 : 0, for: TrackerFieldKeys.gym)
        setIntValue(back ? 1 : 0, for: TrackerFieldKeys.back)
        setIntValue(legs ? 1 : 0, for: TrackerFieldKeys.legs)
        setIntValue(shoulders ? 1 : 0, for: TrackerFieldKeys.shoulders)
        setIntValue(chest ? 1 : 0, for: TrackerFieldKeys.chest)
        setIntValue(biceps ? 1 : 0, for: TrackerFieldKeys.biceps)
        setIntValue(triceps ? 1 : 0, for: TrackerFieldKeys.triceps)
        setIntValue(forearmsGrip ? 1 : 0, for: TrackerFieldKeys.forearmsGrip)
        setIntValue(core ? 1 : 0, for: TrackerFieldKeys.core)
        setIntValue(lateEating ? 1 : 0, for: TrackerFieldKeys.lateEating)
        setIntValue(hydrationOK ? 1 : 0, for: TrackerFieldKeys.hydrationOK)
        setIntValue(chicken ? 1 : 0, for: TrackerFieldKeys.chicken)
        setIntValue(otherMeat ? 1 : 0, for: TrackerFieldKeys.otherMeat)
        setIntValue(mentalClarity ? 1 : 0, for: TrackerFieldKeys.mentalClarity)
        setIntValue(anxietyOverthinking ? 1 : 0, for: TrackerFieldKeys.anxietyOverthinking)
        setIntValue(learnedSomething ? 1 : 0, for: TrackerFieldKeys.learnedSomething)
        setIntValue(readingDone ? 1 : 0, for: TrackerFieldKeys.readingDone)
        setIntValue(meditationStillness ? 1 : 0, for: TrackerFieldKeys.meditationStillness)
        setIntValue(deepWork ? 1 : 0, for: TrackerFieldKeys.deepWork)
        setIntValue(primaryThemeSlotUsed ? 1 : 0, for: TrackerFieldKeys.primaryThemeSlotUsed)
        setIntValue(themeFollowed ? 1 : 0, for: TrackerFieldKeys.themeFollowed)
        setIntValue(familyTime ? 1 : 0, for: TrackerFieldKeys.familyTime)
        setIntValue(connectionFelt ? 1 : 0, for: TrackerFieldKeys.connectionFelt)
        setIntValue(aloneTime ? 1 : 0, for: TrackerFieldKeys.aloneTime)
        setIntValue(selfCareDone ? 1 : 0, for: TrackerFieldKeys.selfCareDone)
        setIntValue(socialInteraction ? 1 : 0, for: TrackerFieldKeys.socialInteraction)
        setIntValue(feltCalm ? 1 : 0, for: TrackerFieldKeys.feltCalm)
        setIntValue(cardioStepsMovement ? 1 : 0, for: TrackerFieldKeys.cardioStepsMovement)

        // text
        setTextValue(currentTheme, for: TrackerFieldKeys.currentTheme)
        setTextValue(dailyNotes, for: TrackerFieldKeys.dailyNotes)

        hasMigratedToDynamicStore = true
    }

    private func decodeNumbers() -> [String: Int] {
        decode([String: Int].self, from: numericValuesBlob) ?? [:]
    }

    private func decodeTexts() -> [String: String] {
        decode([String: String].self, from: textValuesBlob) ?? [:]
    }

    private func encode<T: Encodable>(_ value: T) -> Data {
        (try? JSONEncoder().encode(value)) ?? Data("{}".utf8)
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        try? JSONDecoder().decode(type, from: data)
    }
}
