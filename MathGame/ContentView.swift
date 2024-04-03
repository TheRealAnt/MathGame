//
//  ContentView.swift
//  MathGame
//
//  Created by Antonie Sander on 2024/01/16.
//

import SwiftUI
import AVFoundation
import Combine

struct ContentView: View {
    private enum Difficulty: Int, CaseIterable, Identifiable {
        case easy = 10
        case medium = 100
        case hard = 999
        var id: Self { self }
    }
    
    private enum Problem: String, CaseIterable, Identifiable {
        case addition = "+"
        case subtraction = "−"
        case division = "÷"
        case multiplication = "×"
        var id: Self { self }
    }
    
    private enum Sound: SystemSoundID {
        case correctAnswer = 1026
        case buttonTap = 1104
    }
    
    @State private var correctAnswer = 0
    @State private var choiceArray : [Int] = [0, 1, 2, 3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var score = 0
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var selectedProblem: Problem = .addition
    @State private var timeRemaining = 30
    
//    @Environment(\.scenePhase) var scenePhase
//    @State private var isActive = true
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    configureDifficultyPicker()
                    configureProblemPicker()
                }
                .scrollContentBackground(.hidden)
                // configureTimer()
                configureMathProblemTitle(for: selectedProblem)
                configureAnswerButtonsFirstRow()
                configureAnswerButtonsSecondRow()
                    .padding(.bottom)
                configureScoreTitle()
            }
            .onAppear(perform: {
                generateAnswers(for: selectedProblem)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .light ? LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.cyan]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.4), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationTitle("Math Games")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button(action: {
//                    print("settings tapped!")
//                }, label: {
//                    Image(systemName: "gear")
//                        .renderingMode(.template)
//                        .foregroundColor(.white)
//                })
//                .padding()
//            }
        }
        // TODO: Implement timer
        //        .onReceive(timer) { time in)
        //            guard isActive else { return }
        //            if timeRemaining > 0 {
        //                timeRemaining -= 1
        //            }
        //        }
        //        .onChange(of: scenePhase) {
        //            if scenePhase == .active {
        //                isActive = true
        //            } else {
        //                isActive = false
        //            }
        //        }
    }
    
    private func configureTimer() -> some View {
        AnswerButton(text: "Time: ",
                     number: timeRemaining,
                     width: 130,
                     height: 45,
                     font: .system(size: 25, weight: .bold, design: .rounded))
        .frame(alignment: .trailing)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    }
    
    private func configureDifficultyPicker() -> some View {
        Picker(String(describing: Difficulty.self), selection: $selectedDifficulty) {
            ForEach(Difficulty.allCases) { difficulty in
                Text(String(describing: difficulty.id))
            }
        }
        .pickerStyle(.automatic)
        .onChange(of: selectedDifficulty) { oldDifficulty, newDifficulty in
            switch newDifficulty {
            case .easy:
                selectedDifficulty = .easy
            case .medium:
                selectedDifficulty = .medium
            case .hard:
                selectedDifficulty = .hard
            }
            generateAnswers(for: selectedProblem)
        }
    }
    
    private func configureProblemPicker() -> some View {
        Picker(String(describing: Problem.self), selection: $selectedProblem) {
            ForEach(Problem.allCases) { difficulty in
                Text(String(describing: difficulty.id))
            }
        }
        .pickerStyle(.automatic)
        .onChange(of: selectedProblem) { oldProblem, newProblem in
            switch newProblem {
            case .addition:
                selectedProblem = .addition
            case .subtraction:
                selectedProblem = .subtraction
            case .division:
                selectedProblem = .division
            case .multiplication:
                selectedProblem = .multiplication
            }
            generateAnswers(for: selectedProblem)
        }
    }
    
    private func configureMathProblemTitle(for problem: Problem) -> Text {
        Text("\(firstNumber) \(problem.rawValue) \(secondNumber)")
            .font(.largeTitle)
            .bold()
    }
    
    private func configureAnswerButtonsFirstRow() -> some View {
        HStack {
            ForEach(0..<2) { index in
                configureButton(at: index)
            }
        }
    }
    
    private func configureAnswerButtonsSecondRow() -> some View {
        HStack {
            ForEach(2..<4) { index in
                configureButton(at: index)
            }
        }
    }
    
    private func configureButton(at index: Int) -> some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            answerIsCorrect(answer: choiceArray[index])
            generateAnswers(for: selectedProblem)
        }, label: {
            AnswerButton(number: (choiceArray[index]))
        }).buttonStyle(ButtonScaleEffect())
    }
    
    private func configureScoreTitle() -> some View {
        AnswerButton(text: "Score: ",
                     number: score,
                     width: 130,
                     height: 45,
                     font: .system(size: 25, weight: .bold, design: .rounded))
    }
    
    private func answerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            self.score += 1
            AudioServicesPlaySystemSound(Sound.correctAnswer.rawValue)
        } else if score > 0 {
            AudioServicesPlaySystemSound(Sound.buttonTap.rawValue)
            self.score -= 1
        }
    }
    
    private func generateAnswers(for problem: Problem) {
        firstNumber = Int.random(in: 0...(selectedDifficulty.rawValue/2))
        secondNumber = Int.random(in: 0...(selectedDifficulty.rawValue/2))
        var answerList = [Int]()
        
        switch problem {
        case .addition:
            correctAnswer = firstNumber + secondNumber
        case .subtraction:
            correctAnswer = firstNumber - secondNumber
        case .division:
            correctAnswer = firstNumber / secondNumber
        case .multiplication:
            correctAnswer = firstNumber * secondNumber
        }
        
        for _ in 0...2 {
            answerList.append(Int.random(in: 0...selectedDifficulty.rawValue))
        }
        
        answerList.append(correctAnswer)
        choiceArray = answerList.shuffled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
