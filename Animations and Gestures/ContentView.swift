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
    @State private var selectedWrongAnswer: String?
    
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
                    
                    Choices(answers: shuffledAnswers, correctAnswer: shuffledQuestions[currentQuestionIndex].correctAnswer, selectedWrongAnswer: $selectedWrongAnswer, onIncorrectSelect: incorrectAnswer) { isCorrect in
                        if isCorrect {
                            nextQuestion()
                        } else {
                            incorrectAnswer()
                            nextQuestion()
                        }
                    }
                }
                .transition(.scale)
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
                    Text("Correct Answers: \(shuffledQuestions.count)")
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
        selectedWrongAnswer = nil
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
    @Binding var selectedWrongAnswer: String?
    var onIncorrectSelect: () -> Void
    var onSelect: (Bool) -> Void
    
    var body: some View {
        VStack {
            ForEach(0..<2, id: \.self) { row in
                HStack {
                    ForEach(0..<2, id: \.self) { col in
                        let index = row * 2 + col
                        if index < answers.count {
                            AnswerButton(answer: answers[index], correctAnswer: correctAnswer, onIncorrectSelect: onIncorrectSelect, onSelect: onSelect, selectedWrongAnswer: $selectedWrongAnswer)
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
    var onIncorrectSelect: () -> Void
    var onSelect: (Bool) -> Void
    
    @Binding var selectedWrongAnswer: String?
    @State private var jiggle = false
    @State private var showRed = false
    @State private var isCorrectAnswer = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Text(answer)
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(showRed ? Color.red : Color.green))
            .foregroundColor(.white)
            .scaleEffect(scale)
            .offset(x: jiggle ? -12 : 12)
            .animation(jiggle ? Animation.easeInOut(duration: 0.1).repeatCount(5, autoreverses: true) : .default, value: jiggle)
            .onTapGesture {
                let isCorrect = answer == correctAnswer
                if isCorrect {
                    isCorrectAnswer = true
                    withAnimation(.easeIn(duration: 0.5)) {
                                            scale = 30
                                        }
                    selectedWrongAnswer = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation {
                                                scale = 1.0
                                            }
                                            onSelect(true)
                                        }
                } else {
                    selectedWrongAnswer = answer
                    showRed = true
                    jiggleEffect()
                    onIncorrectSelect()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(nil){
                            showRed = false
                        }
                    }
                }
            }
    }
    
    private func jiggleEffect() {
        jiggle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            jiggle = false
        }
    }
}


#Preview {
    ContentView()
}
