//
//  ContentView.swift
//  Animations and Gestures
//
//  Created by Kyle Kaufman on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentQuestionIndex = 0
    @State private var shuffledQuestions: [Quiz]
    @State private var showQuiz = false
    @State private var incorrectAnswers = 0
    @State private var showScore = false
    
    init() {
        _shuffledQuestions = State(initialValue: QuizData.allQuestions.shuffled()) // Shuffle questions
    }
    
    var body: some View {
        VStack {
            if showQuiz && !showScore {
                // Show quiz
                VStack(spacing: 20) {
                    Text(shuffledQuestions[currentQuestionIndex].question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Shuffle answers for this question
                    let shuffledAnswers = shuffledQuestions[currentQuestionIndex].answers.shuffled()
                    
                    Choices(answers: shuffledAnswers, correctAnswer: shuffledQuestions[currentQuestionIndex].correctAnswer) { isCorrect in
                        if isCorrect {
                            nextQuestion()
                        } else {
                            incorrectAnswer()
                            nextQuestion()
                        }
                    }
                }
            } else if !showScore {
                // Show welcome screen
                VStack {
                    Text("Welcome to Quizzo!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Button("Begin") {
                        withAnimation {
                            showQuiz = true
                        }
                    }
                    .padding()
                    .font(.title)
                    .background(Capsule().fill(Color.green))
                    .foregroundColor(.white)
                }
                .padding()
            }
            
            if showScore {
                VStack {
                    Text("Quiz Finished!")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Correct Answers: \(shuffledQuestions.count -  incorrectAnswers)")
                        .font(.title2)
                    Text("Incorrect Answers: \(incorrectAnswers)")
                        .font(.title2)
                    Button("Retake Quiz") {
                        resetQuiz()
                    }
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < shuffledQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showScore = true
        }
    }
    
    private func incorrectAnswer() {
        // Increment incorrect answers counter
        incorrectAnswers += 1
    }
    
    private func resetQuiz() {
        incorrectAnswers = 0
        currentQuestionIndex = 0
        shuffledQuestions.shuffle() // Shuffle the questions for a new round
        showQuiz = true
        showScore = false
    }
}

struct Choices: View {
    let answers: [String]
    let correctAnswer: String
    var onSelect: (Bool) -> Void
    
    var body: some View {
        VStack {
            ForEach(0..<2, id: \.self) { row in
                HStack {
                    ForEach(0..<2, id: \.self) { col in
                        let index = row * 2 + col
                        if index < answers.count {
                            AnswerButton(answer: answers[index], correctAnswer: correctAnswer) { isCorrect in
                                onSelect(isCorrect)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AnswerButton: View {
    let answer: String
    let correctAnswer: String
    var onSelect: (Bool) -> Void
    
    var body: some View {
        Text(answer)
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(Color.green))
            .foregroundColor(.white)
            .onTapGesture {
                let isCorrect = answer == correctAnswer
                onSelect(isCorrect)
            }
    }
}

#Preview {
    ContentView()
}
