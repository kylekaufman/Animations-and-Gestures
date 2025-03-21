//
//  Quiz.swift
//  Animations and Gestures
//
//  Created by Emmanuel Makoye on 3/21/25.
//


import Foundation

struct Quiz: Identifiable {
    var id: UUID = UUID()
    var question: String
    var answers: [String]
    var correctAnswer: String
}

struct QuizData {
    static let allQuestions: [Quiz] = [
        // Geography
        Quiz(question: "Which country has the most deserts?", answers: ["Australia", "Brazil", "Canada", "Russia"], correctAnswer: "Australia"),
        Quiz(question: "What is the longest river in the world?", answers: ["Amazon", "Nile", "Yangtze", "Mississippi"], correctAnswer: "Nile"),
        Quiz(question: "Which continent is the largest by land area?", answers: ["Africa", "Asia", "Europe", "North America"], correctAnswer: "Asia"),
        
        // Math
        Quiz(question: "What is the square root of 16?", answers: ["2", "4", "6", "8"], correctAnswer: "4"),
        Quiz(question: "What is 5 × 3?", answers: ["10", "12", "15", "18"], correctAnswer: "15"),
        Quiz(question: "How many sides does a hexagon have?", answers: ["4", "5", "6", "7"], correctAnswer: "6"),
        
        // Science
        Quiz(question: "Which planet is known as the Red Planet?", answers: ["Venus", "Mars", "Jupiter", "Saturn"], correctAnswer: "Mars"),
        Quiz(question: "What gas do plants primarily use for photosynthesis?", answers: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"], correctAnswer: "Carbon Dioxide"),
        Quiz(question: "What is the chemical symbol for water?", answers: ["H2O", "CO2", "O2", "NaCl"], correctAnswer: "H2O")
    ]
}
