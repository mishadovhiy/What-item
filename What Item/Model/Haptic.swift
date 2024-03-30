//
//  Haptic.swift
//  What Item
//
//  Created by Misha Dovhiy on 30.03.2024.
//  Copyright © 2024 Misha Dovhiy. All rights reserved.
//

import CoreHaptics

struct Haptic {
    private var engine: CHHapticEngine?
    init() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error initializing haptic engine: \(error.localizedDescription)")
        }
    }
    
    func vibrate() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        guard let pattern = try? CHHapticPattern(events: [event], parameters: []) else {
            print("cantvibrate")
            return
        }
        let player = try? engine?.makePlayer(with: pattern)
        
        do {
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Error playing haptic: \(error.localizedDescription)")
        }
    }
}
