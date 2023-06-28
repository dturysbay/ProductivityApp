//
//  Enums.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 23.06.2023.
//

import Foundation

enum ProjectViewState{
    case kanban
    case matrix
    case news
    case pomodoro
}

enum StorageStates: String{
    case focusValue
    case time
}

enum FocusCategory: String{
    case work
    case study
    case workout
    case reading
    case meditation
    case other
}

enum ScreenState {
    case loginView
    case signUpView
    case userAutorized
}

enum TimerState{
    case playing
    case paused
    case stopped
}
