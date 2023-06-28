//
//  TaskManager.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 20.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TaskManagerController:ObservableObject {

    private let db = Firestore.firestore()

    @Published var statuses: [String] = []
    @Published var tasks:[ProjectTask] = []
    @Published var projectUsers:[ProjectUser] = []
    @Published var tasksByMatrix:[ProjectTask] = []
    
    func addTask(_ task: Task, completion: @escaping (Bool) -> Void) {
            let taskRef = db.collection("tasks").document()
            let user = Auth.auth().currentUser?.uid
            let taskData: [String: Any] = [
                "projectDocumentId": task.projectDocumentId,
                "assignedTo": task.assignedTo,
                "createdBy": user!,
                "title": task.title,
                "description": task.description,
                "kanbanStatus": task.kanbanStatus,
                "importanceStatus": task.importanceStatus,
                "urgencyStatus": task.urgencyStatus,
                "createdAt": task.createdAt
            ]
            
            taskRef.setData(taskData) { error in
                if let error = error {
                    print("Error adding task: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
        
    func fetchProjectUsers(projectDocumentId: String) {
        var users: [ProjectUser] = []
        
        db.collection("user_project").whereField("projectDocumentId", isEqualTo: projectDocumentId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                for document in querySnapshot!.documents {
                    let userDocumentId = document.data()["userDocumentId"] as! String
                    dispatchGroup.enter()
                    
                    self.db.collection("users").document(userDocumentId).getDocument { (document, error) in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let document = document, document.exists {
                            let data = document.data()
                            let userData = ProjectUser(
                                docId:  document.documentID,
                                name: data?["name"] as? String ?? "",
                                surname: data?["surname"] as? String ?? ""
                            )
                            users.append(userData)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.projectUsers = users
                }
            }
    }
        
    func fetchTasks(forProject projectId: String) {
        var tasksByStatus: [String: [Task]] = [:]
        var projectTasks: [ProjectTask] = []
        let dispatchGroup = DispatchGroup()

        var tasksCollection: CollectionReference {
            return db.collection("tasks")
        }

        fetchStatuses(forProject: projectId) { statuses in
            for status in statuses {
                print(status)
                dispatchGroup.enter()

                let query = tasksCollection
                    .whereField("projectDocumentId", isEqualTo: projectId)
                    .whereField("kanbanStatus", isEqualTo: status)

                query.getDocuments { (snapshot, error) in
                    defer { dispatchGroup.leave() }

                    if let error = error {
                        print("Error fetching tasks: \(error.localizedDescription)")
                        return
                    }

                    for document in snapshot!.documents {
                        let data = document.data()
                        let task = Task(
                            docId: document.documentID,
                            projectDocumentId: data["projectDocument"] as? String ?? "",
                            assignedTo: data["assignedTo"] as? String ?? "",
                            createdBy: data["createdBy"] as? String ?? "",
                            title: data["title"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            kanbanStatus: data["kanbanStatus"] as? String ?? "",
                            importanceStatus: data["importanceStatus"] as? String ?? "",
                            urgencyStatus: data["urgencyStatus"] as? String ?? "",
                            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                            deadline:(data["deadline"] as? Timestamp)?.dateValue() ?? Date()
                        )

                        if tasksByStatus[status] == nil {
                            tasksByStatus[status] = [task]
                        } else {
                            tasksByStatus[status]?.append(task)
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                for status in statuses {
                    let tasksForStatus = tasksByStatus[status] ?? []
                    let projectTask = ProjectTask(status: status, tasks: tasksForStatus)
                    projectTasks.append(projectTask)
                }
                self.tasks = projectTasks
            }
        }
    }
    
    func fetchTasksByMatrix(forProject projectId: String) {
        var tasksByStatus: [String: [Task]] = [
            "Important/Urgent": [],
            "Important/Not Urgent": [],
            "Not Important/Urgent": [],
            "Not Important/Not Urgent": []
        ]
        var projectTasks: [ProjectTask] = []

        let dispatchGroup = DispatchGroup()

        var tasksCollection: CollectionReference {
            return db.collection("tasks")
        }

        dispatchGroup.enter()

        let query = tasksCollection
            .whereField("projectDocumentId", isEqualTo: projectId)

        query.getDocuments { (snapshot, error) in
            defer { dispatchGroup.leave() }

            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }

            for document in snapshot!.documents {
                let data = document.data()
                let task = Task(
                    docId: document.documentID,
                    projectDocumentId: data["projectDocument"] as? String ?? "",
                    assignedTo: data["assignedTo"] as? String ?? "",
                    createdBy: data["createdBy"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    kanbanStatus: data["kanbanStatus"] as? String ?? "",
                    importanceStatus: data["importanceStatus"] as? String ?? "",
                    urgencyStatus: data["urgencyStatus"] as? String ?? "",
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                    deadline: (data["deadline"] as? Timestamp)?.dateValue() ?? Date()
                )

                if task.importanceStatus == "Important" && task.urgencyStatus == "Urgent" {
                    tasksByStatus["Important/Urgent"]?.append(task)
                } else if task.importanceStatus == "Important" && task.urgencyStatus == "Not Urgent" {
                    tasksByStatus["Important/Not Urgent"]?.append(task)
                } else if task.importanceStatus == "Not Important" && task.urgencyStatus == "Urgent" {
                    tasksByStatus["Not Important/Urgent"]?.append(task)
                } else if task.importanceStatus == "Not Important" && task.urgencyStatus == "Not Urgent" {
                    tasksByStatus["Not Important/Not Urgent"]?.append(task)
                }
            }
        }
            
        dispatchGroup.notify(queue: .main) {
            let orderedKeys = ["Important/Urgent", "Important/Not Urgent", "Not Important/Urgent", "Not Important/Not Urgent"]
            
            for status in orderedKeys {
                if let tasksForStatus = tasksByStatus[status] {
                    let projectTask = ProjectTask(status: status, tasks: tasksForStatus)
                    projectTasks.append(projectTask)
                }
            }
            
            self.tasksByMatrix = projectTasks
        }
    }
    
    func fetchStatuses(forProject projectId: String, completion: @escaping ([String]) -> Void) {
        db.collection("projects").document(projectId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching states and tasks: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var states = [String]()
            
            if let data = snapshot?.data(), let statesArray = data["states"] as? [String] {
                states = statesArray
            }
            self.statuses = states
            completion(states)
        }
    }
    
    func fetchUserId(by id: String, completion: @escaping (ProjectUser?) -> Void) {
        let docRef = db.collection("users").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let userData = ProjectUser(
                    docId:  document.documentID,
                    name: data?["name"] as? String ?? "",
                    surname: data?["surname"] as? String ?? ""
                )
                completion(userData)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func updateProjectById(task: Task,for role: String){
        if(role != "user"){
            db.collection("tasks").document(task.docId ?? "").updateData([
                "assignedTo": task.assignedTo,
                "createdBy": task.createdBy,
                "title": task.title,
                "description": task.description,
                "kanbanStatus": task.kanbanStatus,
                "importanceStatus": task.importanceStatus,
                "urgencyStatus": task.urgencyStatus,
                "createdAt": task.createdAt,
                "deadline": task.deadline
            ]){
                err in
                   if let err = err {
                       print("Error updating document: \(err)")
                   } else {
                       print("Document successfully updated")
                   }
            }
        }else{
            db.collection("tasks").document(task.docId ?? "").updateData([
            
                "kanbanStatus":task.kanbanStatus
            ])
        }
    }
    func deleteTaskById(taskID: String) {
        db.collection("tasks").document(taskID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func isTaskAssignedToCurrentUser(taskId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No current user")
            return
        }
        
        let docRef = db.collection("tasks").document(taskId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data(), let assignedTo = data["assignedTo"] as? String {
                if assignedTo == userId {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
}
