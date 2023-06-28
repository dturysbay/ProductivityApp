//
//  Project.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 09.06.2023.
//

import Foundation

struct Project: Identifiable{
    let id: String
    let title: String
    let description: String
    let createdBy: String
    let createdAt: Date
    let states: [String]
}

struct ProjectUser:Hashable,Identifiable {
    let docId: String
    let name: String
    let surname: String
    var id: String { docId }
}

struct ProjectTask: Identifiable,Hashable {
    let status: String
    let tasks: [Task]
    let id = UUID()
}

