////
////  UserViewController.swift
////  ProductivityApp
////
////  Created by Dinmukhambet Turysbay on 09.06.2023.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//class UserViewController: ObservableObject {
//
//    @Published var projects:[Project] = [Project]()
//    @Published var alertmessage: String = ""
//    @Published var isShowingAlert: Bool = false
//    @Published var title = ""
//    @Published var description = ""
//    @Published var showSheet = false
////    let db = Firestore.firestore()
//    private var db = Firestore.firestore()
//
//    func addProject() {
//        let db = Firestore.firestore()
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//
//        guard !title.isEmpty, !description.isEmpty else{
//            self.alertmessage = "Fields can not be empty"
//            self.isShowingAlert = true
//            return
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let createdAt = dateFormatter.string(from: Date())
//
//        let projectData: [String: Any] = [
//               "title": title,
//               "description": description,
//               "createdBy": userId,
//               "createdAt": createdAt,
//               "states":["To Do", "In Progress","Done"]
//           ]
//
//        var ref: DocumentReference? = nil
//        ref = db.collection("projects").addDocument(data: projectData) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//
//                let userProjectData: [String: Any] = [
//                    "userDocumentId": userId,
//                    "projectDocumentId": ref!.documentID,
//                    "role": "owner"
//                ]
//
//                db.collection("user_project").addDocument(data: userProjectData) { err in
//                    if let err = err {
//                        print("Error adding user_project document: \(err)")
//                    } else {
//                        print("User_project document added")
////                        self.fetchUserProjects()
//                        self.title = ""
//                        self.description = ""
//                        self.showSheet = false
//                    }
//                }
//            }
//        }
//    }
//
//    func fetchUserProjects() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//
//
//
//        let userProjectQuery = self.db.collection("user_project").whereField("userDocumentId", isEqualTo: userId)
//
//        userProjectQuery.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                self.projects = []
//                for document in querySnapshot!.documents {
//                    let projectDocumentId = document.data()["projectDocumentId"] as! String
//                    self.db.collection("projects").document(projectDocumentId).getDocument { (projectDocument, err) in
//                        if let projectDocument = projectDocument, projectDocument.exists {
//                            let data = projectDocument.data()
//                            let project = Project(
//                                id: projectDocument.documentID,
//                                title: data?["title"] as? String ?? "",
//                                description: data?["description"] as? String ?? "",
//                                createdBy: data?["createdBy"] as? String ?? "",
//                                createdAt: (data?["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
//                                states: (data?["states"] as? [String] ?? [""])
//                            )
//                            DispatchQueue.main.async {
//                                self.projects.append(project)
//                            }
//                        } else {
//                            print("Project document does not exist")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//}

//
//  UserViewController.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 09.06.2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserViewController: ObservableObject {
    
    @Published var projects:[Project] = [Project]()
    @Published var alertmessage: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var title = ""
    @Published var description = ""
    @Published var showSheet = false
//    let db = Firestore.firestore()
    
    init() {
        fetchUserProjects()
    }
    
    private let db = Firestore.firestore()
    
    func addProject() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        guard !title.isEmpty, !description.isEmpty else{
            self.alertmessage = "Fields can not be empty"
            self.isShowingAlert = true
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let createdAt = dateFormatter.string(from: Date())
        
        let projectData: [String: Any] = [
               "title": title,
               "description": description,
               "createdBy": userId,
               "createdAt": createdAt,
               "states":["To Do", "In Progress","Done"]
           ]
        
        var ref: DocumentReference? = nil
        ref = db.collection("projects").addDocument(data: projectData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                let userProjectData: [String: Any] = [
                    "userDocumentId": userId,
                    "projectDocumentId": ref!.documentID,
                    "role": "owner"
                ]
                
                db.collection("user_project").addDocument(data: userProjectData) { err in
                    if let err = err {
                        print("Error adding user_project document: \(err)")
                    } else {
                        print("User_project document added")
//                        self.fetchUserProjects()
                        self.title = ""
                        self.description = ""
                        self.showSheet = false
                    }
                }
            }
        }
    }

    func fetchUserProjects() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print("userId",userId)
        let userProjectQuery = self.db.collection("user_project").whereField("userDocumentId", isEqualTo: userId)

        userProjectQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dispatchGroup = DispatchGroup()
                for document in querySnapshot!.documents {
                    let projectDocumentId = document.data()["projectDocumentId"] as! String

                    dispatchGroup.enter()
                    self.db.collection("projects").document(projectDocumentId).getDocument { (projectDocument, err) in
                        defer {
                            dispatchGroup.leave()
                        }
                        if let projectDocument = projectDocument,projectDocument.exists {
                            let data = projectDocument.data()
                            let project = Project(
                                id: projectDocument.documentID,
                                title: data?["title"] as? String ?? "",
                                description: data?["description"] as? String ?? "",
                                createdBy: data?["createdBy"] as? String ?? "",
                                createdAt: (data?["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                                states: (data?["states"] as? [String] ?? [""])
                            )
                            dispatchGroup.notify(queue: .main) {
                                self.projects.append(project)
                            }
//                            DispatchQueue.main.async {
//                                self.projects.append(project)
//                            }
                        } else {
                            print("Project document does not exist")
                        }
                    }
                }
                print(self.projects)
            }
        }
    }

}

