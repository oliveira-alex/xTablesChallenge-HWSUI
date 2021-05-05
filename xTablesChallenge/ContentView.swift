//
//  ContentView.swift
//  xTablesChallenge
//
//  Created by Alex Oliveira on 03/05/2021.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTables: [Int] = []
    @State private var questionsQuantity = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Which tables do you want to practice?")

                HStack {
                    ForEach(1 ..< 5) { num in
                        Button(action:{
                            if let numIndex = selectedTables.firstIndex(of: num) {
                                // deactivated color button
                                selectedTables.remove(at: numIndex)
                            } else {
                                // activated color button
                                selectedTables.append(num)
                            }
                        }) {
                           Text("\(num)")
                            .foregroundColor(selectedTables.contains(num) ? .blue : .red)
                        }
                    }
                }

                HStack {
                    ForEach(5 ..< 9) { num in
                        Button(action:{
                            if let numIndex = selectedTables.firstIndex(of: num) {
                                // deactivated color button
                                selectedTables.remove(at: numIndex)
                            } else {
                                // activated color button
                                selectedTables.append(num)
                            }
                        }) {
                           Text("\(num)")
                            .foregroundColor(selectedTables.contains(num) ? .blue : .red)
                        }
                    }
                }

                HStack {
                    ForEach(9 ..< 13) { num in
                        Button(action:{
                            if let numIndex = selectedTables.firstIndex(of: num) {
                                // deactivated color button
                                
                                selectedTables.remove(at: numIndex)
                            } else {
                                // activated color button
                                
                                selectedTables.append(num)
                            }
                        }) {
                           Text("\(num)")
                            .foregroundColor(selectedTables.contains(num) ? .blue : .red)
                        }
                    }
                }
            }
            
            VStack {
                Text("How many questions do you want to anwer?")
                
                HStack {
                    ForEach(0 ..< 3) {
                        let buttonNumber = Int(5.0 * pow(2.0, Double($0)))
                        let buttonTitle = String(buttonNumber)
                        Button(buttonTitle) {
                            self.questionsQuantity = String(buttonTitle)
                        }
                        .foregroundColor(buttonTitle == questionsQuantity ? .blue : .red)
                    }
                    
                    Button("All") {
                        self.questionsQuantity = "All"
                    }
                    .foregroundColor(questionsQuantity == "All" ? .blue : .red)
                }
            }
        }
    }
    
    func getSelectedTables() -> [Int] { selectedTables }
    func getQuestionsQuantity() -> String { questionsQuantity }
}

struct GamingView: View {
    @State private var questionTxt = ""
    @State private var answerTxt = ""
    private var aswer: Int {
        return Int(answerTxt) ?? 0
    }
    
    @State private var randomQuestions: [(Int, Int)] = [(99, 99)]
    @State private var currentQuestionIndex = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text(questionTxt)
                .font(.title)
            
            if currentQuestionIndex < randomQuestions.count {
                TextField("Answer", text: $answerTxt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 150)
                
                Text("Question \(currentQuestionIndex + 1) of \(randomQuestions.count)")
            } else {
                // Score
                // Play again?
            }
        }
    }
    
    func setQuestions(_ questionsArray: [(Int, Int)]) {
        randomQuestions = questionsArray
    }
    
    func askQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < randomQuestions.count {
            let currentQuestion = randomQuestions[currentQuestionIndex]
            questionTxt = "What is \(currentQuestion.0) x \(currentQuestion.1) ?"
        } else {
            questionTxt = "No more questions"
        }
    }
}

struct Questions {
    let selectedTables: [Int]
    let questionsQuantityString: String
    
    var questions: [(Int, Int)] {
        let questionsQuantity: Int
        switch questionsQuantityString {
        case "5", "10", "20":
            questionsQuantity = Int(questionsQuantityString)!
        default:
            questionsQuantity = 12 * selectedTables.count
        }
        
        var completeTable: [Int] = []
        for num in 1 ..< 13 {
            completeTable.append(num)
        }
        
        var allPossibleQuestions: [[Int]] = []
        for _ in 0 ..< selectedTables.count {
            allPossibleQuestions.append(completeTable.sorted())
        }
        
        var questionsArray: [(Int, Int)] = []
        for _ in 0 ..< questionsQuantity {
            var tableIndex = -1
            repeat {
                tableIndex = Int.random(in: 0 ..< selectedTables.count)
            } while (allPossibleQuestions[tableIndex].isEmpty)
            
            let table = selectedTables[tableIndex]
            let multiplier = allPossibleQuestions[tableIndex].popLast()!
            
            questionsArray.append((table, multiplier))
        }
        return questionsArray
    }
}

struct ContentView: View {
    @State private var isGameActive = false
    var settingsView = SettingsView()
    var gamingView = GamingView()
    
    @State private var selectedTables: [Int] = []
    @State private var questionsQuantity = ""
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                if isGameActive {
                    gamingView
                        .transition(.slide)
                        .onAppear(perform: {
                            let questions = Questions(selectedTables: selectedTables, questionsQuantityString: questionsQuantity).questions
                            
                            gamingView.setQuestions(questions)
                            gamingView.askQuestion()
                        })
                } else {
                    settingsView
                        .transition(.slide)
                        .onDisappear(perform: {
                            self.selectedTables =  settingsView.getSelectedTables()
                            self.questionsQuantity =  settingsView.getQuestionsQuantity()
                        })
                }
                
                Spacer()
                
                Button(isGameActive ? "Submit" : "Start") {
                    withAnimation(.easeOut) {
                        self.isGameActive.toggle()
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("xTables")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        SettingsView()
//        GamingView()
    }
}
