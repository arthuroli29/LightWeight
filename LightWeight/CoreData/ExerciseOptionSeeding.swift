//
//  ExerciseOptionSeeding.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 05/12/24.
//

import Foundation

enum ExerciseOptionSeeding {
	struct ExerciseOptionSeed {
		let name: String
		let id: UUID
	}
	static let options: [ExerciseOptionSeed] = [
		ExerciseOptionSeed(name: "Barbell", id: UUID(uuidString: "7B1A7B27-C848-4952-A391-DE7BB23504C3") ?? UUID()),
		ExerciseOptionSeed(name: "Dumbbell", id: UUID(uuidString: "D4E2C4A1-F836-4B2E-9D71-ABC123456789") ?? UUID()),
		ExerciseOptionSeed(name: "Kettlebell", id: UUID(uuidString: "8F9E5D3B-A2C1-4F7E-B890-123456789ABC") ?? UUID()),
		ExerciseOptionSeed(name: "Bodyweight", id: UUID(uuidString: "E1D2C3B4-A5F6-47E8-9D0C-987654321DEF") ?? UUID())
	]
}
