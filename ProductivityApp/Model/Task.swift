//
//  Task.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 12.06.2023.
//

import Foundation

struct Task:Hashable {
    let docId: String?
    let projectDocumentId: String
    let assignedTo: String
    let createdBy: String
    let title: String
    let description: String
    let kanbanStatus: String
    let importanceStatus: String
    let urgencyStatus: String
    let createdAt: Date
    let deadline: Date
}

