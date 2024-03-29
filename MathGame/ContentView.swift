//
//  ContentView.swift
//  MathGame
//
//  Created by Antonie Sander on 2024/01/16.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    enum Difficulty: Int, CaseIterable, Identifiable {
        case easy = 10
        case medium = 100
        case hard = 999
        var id: Self { self }
    }
    @State private var correctAnswer = 0
    @State private var choiceArray : [Int] = [0, 1, 2, 3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var score = 0
    @State private var selectedDifficulty: Difficulty = .easy
    
    var body: some View {
        VStack {
            Spacer()
            Picker("Difficulty", selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases) { difficulty in
                    Text(String(describing: difficulty.id))
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedDifficulty) { oldValue, newValue in
                switch newValue {
                case .easy:
                    selectedDifficulty = .easy
                case .medium:
                    selectedDifficulty = .medium
                case .hard:
                    selectedDifficulty = .hard
                }
                generateAnswers()
            }
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber)")
                .font(.largeTitle)
                .bold()
            
            HStack {
                ForEach(0..<2) { index in
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        answerIsCorrect(answer: choiceArray[index])
                        generateAnswers()
                    }, label: {
                        AnswerButton(number: (choiceArray[index]))
                    }).buttonStyle(ScaleButtonStyle())
                }
            }
            
            HStack {
                ForEach(2..<4) { index in
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        answerIsCorrect(answer: choiceArray[index])
                        generateAnswers()
                    }, label: {
                        AnswerButton(number: (choiceArray[index]))
                    }).buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.bottom)
            
            Text("Score: \(score)")
                .font(.title2)
                .bold()
                .foregroundStyle(Color(.label))
            
            Spacer()
        }
        .onAppear(perform: generateAnswers)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    func answerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            self.score += 1
            AudioServicesPlaySystemSound(1026)
        } else {
            AudioServicesPlaySystemSound(1104)
            self.score -= 1
        }
    }
    
    func generateAnswers() {
        firstNumber = Int.random(in: 0...(selectedDifficulty.rawValue/2))
        secondNumber = Int.random(in: 0...(selectedDifficulty.rawValue/2))
        var answerList = [Int]()
        
        correctAnswer = firstNumber + secondNumber
        
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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
