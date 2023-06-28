//
//  Components.swift
//  Pomodoro
//
//  Created by Dinmukhambet Turysbay on 21.04.2023.
//

import SwiftUI

struct TimerViewSample: View {
    
    @State
    private var currentTimerState: TimerState = .playing
    
    private var timerButtonImage: String{
        switch currentTimerState{
        case .playing:
            return "play"
        case .paused:
            return "pause"
            
        case .stopped:
            return "stop.fill"
        }
    }
    private func changePlayOrPauseState(){
        switch currentTimerState{
        case .playing:
            currentTimerState = .paused
        case .paused:
            currentTimerState = .playing
        case .stopped:
            break
        }
    }
    
    @State var counter: Int = 0
    var isTimerOn: Bool = false
    @State var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    @ObservedObject var stopWatch = Stop_Watch()
    
    
    var body: some View {
        VStack{
            ZStack{
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 248, height: 258)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 6)
                                .opacity(0.3)
                    )
    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().trim(from:0, to: progress())
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 6,
                                        lineCap: .round,
                                        lineJoin:.round
                                    )
                                )
                                .foregroundColor(
                                    (completed() ? Color.white.opacity(0.3) : Color.white)
                                )
                                .animation(
                                    .linear(duration: 1), value: 1
                                )
                        )
    
                VStack{
                    Clock(counter: self.stopWatch.counter, countTo: self.stopWatch.countTo)
                    Text("Focus on your task")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
            }
            
            HStack(spacing:80){
                TimerButton(imageName: timerButtonImage, action: {
                    changePlayOrPauseState()
                    if currentTimerState == .playing{
                        self.stopWatch.stop()
                    }else{
                        self.stopWatch.start()
                    }
                    
                })
                TimerButton(imageName: "stop.fill", action: {
                    self.stopWatch.reset()
                })
            }
        }
    }


    func completed() -> Bool {
        return progress() == 1
    }

    func progress() -> CGFloat {
        return (CGFloat(self.stopWatch.counter) / CGFloat(self.stopWatch.countTo))
    }
}

struct Clock: View {
    var counter: Int
    var countTo: Int

    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.system(size: 44))
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
    }

    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)

        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

class Stop_Watch: ObservableObject {
    
    @Published var counter: Int = 0
    @Published var countTo: Int = 1500 //4 minutes 120 - 2minutes
    
    var timer = Timer()
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                   repeats: true) { _ in
            
                    if (self.counter < self.countTo) {
                        self.counter += 1
                    }
        }
    }
    func stop() {
        self.timer.invalidate()
    }
    func reset() {
        self.counter = 0
        self.timer.invalidate()
    }
}

struct TimerButton: View{
    let imageName: String
    let action: () -> ()
    
    var body: some View{
        Button(action: {
            action()
            
        }, label: {
            ZStack{
                Circle()
                    .frame(width: 56,height: 56)
                    .foregroundColor(.white.opacity(0.3))
                
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 16,height: 16)
                    .foregroundColor(.white)
            }
        })
    }
}

struct FocusButton: View{
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color

    init(_ text: String,
         backgroundColor: Color = .customGray,
         foregroundColor: Color = .black ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 16,style: .continuous)
                .fill(backgroundColor)
                .frame(height: 60)
            Text(text)
                .font(.system(size: 16,weight: .semibold))
                .foregroundColor(foregroundColor)
            
        }
    }
}

struct ChangeFocusSheet: View{
    @Binding var isChangeFocusSheetShown: Bool
    @Binding var focusCategory:FocusCategory
    var body: some View{
        VStack{
            HStack {
                Spacer()
                Text("Focus Category")
                    .font(.system(size: 16))
                Spacer()
                Image("close_btn")
                    .onTapGesture {
                        isChangeFocusSheetShown.toggle()
                    }
            }
            .padding(.bottom,40)
            HStack{
                FocusButton("Work",
                        backgroundColor: focusCategory == .work ? .black : .customGray,
                            foregroundColor: focusCategory == .work ? .white : .black
                )
                    .onTapGesture {
                        focusCategory = .work
                        PomodoroStorage.focusName = .work
                        isChangeFocusSheetShown.toggle()
                    }
                FocusButton("Study",
                            backgroundColor: focusCategory == .study ? .black : .customGray,
                            foregroundColor: focusCategory == .study ? .white : .black
                )
                    .onTapGesture {
                        focusCategory = .study
                        PomodoroStorage.focusName = .study
                        isChangeFocusSheetShown.toggle()
                    }
            }
            HStack{
                FocusButton("Workout",
                            backgroundColor: focusCategory == .workout ? .black : .customGray,
                            foregroundColor: focusCategory == .workout ? .white : .black
                )
                    .onTapGesture {
                        focusCategory = .workout
                        PomodoroStorage.focusName = .workout
                        isChangeFocusSheetShown.toggle()
                    }
                FocusButton("Reading",
                            backgroundColor: focusCategory == .reading ? .black : .customGray,
                            foregroundColor: focusCategory == .reading ? .white : .black
                )
                    .onTapGesture {
                        focusCategory = .reading
                        PomodoroStorage.focusName = .reading
                        isChangeFocusSheetShown.toggle()
                    }
            }
            HStack{
                FocusButton("Meditation",
                            backgroundColor: focusCategory == .meditation ? .black : .customGray,
                            foregroundColor: focusCategory == .meditation ? .white : .black
                )
                    .onTapGesture {
                        focusCategory = .meditation
                        PomodoroStorage.focusName = .meditation
                        isChangeFocusSheetShown.toggle()
                    }
                FocusButton("Other",
                            backgroundColor: focusCategory == .other ? .black : .customGray,
                            foregroundColor: focusCategory == .other ?.white : .black
                )
                    .onTapGesture {
                        focusCategory = .other
                        PomodoroStorage.focusName = .other
                        isChangeFocusSheetShown.toggle()
                    }
            }
        }
        .padding(.horizontal,16)
        .interactiveDismissDisabled(isChangeFocusSheetShown)
    }
}

struct CustomLabel: View{
    let text: String
    var body: some View{
        Text(text)
            .font(.system(size: 12))
            .foregroundColor(Color.gray)
    }
}

struct Line: View{
    var body: some View {
        Rectangle()
            .frame(width: 350, height: 1)
            .foregroundColor(.white)
    }
}

struct TaskRowView: View {
    @EnvironmentObject var projectData: ProjectViewController
    @EnvironmentObject var taskManagerController: TaskManagerController
    @Binding var isEditSheetPresented: Bool
    @Binding var isAddTaskSheetPresented: Bool
    @Binding var selectedTask: Task?
    
    var projTask: Task

    var body: some View {
        HStack {
            Text(projTask.title)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                   .italic()
        }
        .swipeActions {
            Group{
                if projectData.role == "admin" || projectData.role == "owner" {
                    Button(role: .destructive) {
                        taskManagerController.deleteTaskById(taskID: projTask.docId ?? "")
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }.tint(Color.red)
                }
            }
            
            Button {
                print("Edit \(projTask)")
                isEditSheetPresented = true
                selectedTask = projTask
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}
