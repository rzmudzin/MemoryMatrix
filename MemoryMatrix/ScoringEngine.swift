//
//  ScoringEngine.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import Foundation

//Easy
//1) Start off with 100 points
//2) Lose 2 points for every mismatch
//3) 20 points added fpr every match

//Medium
//1) Start off with 200 points
//2) Lose 2 points for every mismatch
//3) 20 points added fpr every match

//Hard
//1) Start off with 300 points
//2) Lose 2 points for every mismatch
//3) 20 points added fpr every match

class ScoringEngine {
	private var gameScore = 0
	private let mismatchPoints = 2
	private let matchPoints = 20
	private let level: Level
	private var mismatchedEvents = 0
	private var matchedEvents = 0
	
	init(gameLevel: Level) {
		level = gameLevel
		gameScore = gameLevel == .Easy ? 100 : gameLevel == .Medium ? 200 : 300
	}
	var matched: Int {
		get {
			matchedEvents
		}
	}
	var mismatched: Int {
		get {
			mismatchedEvents
		}
	}
	func onMismatch() {
		mismatchedEvents += 1
		gameScore -= mismatchPoints
	}
	func onMatch() {
		if gameScore >= mismatchPoints {
			matchedEvents += 1
			gameScore += matchPoints
		}
	}
	var score: Int {
		get {
			gameScore
		}
	}
}
