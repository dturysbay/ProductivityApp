//
//  ProjectViewController.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 11.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProjectViewController: ObservableObject{
    
    @Published var showAddUserSheet = false
    @Published var email = ""
    @Published var role = ""
    
    @Published var showRegisterNewUserSheet = false
    @Published var name = ""
    @Published var surname = ""
    @Published var dateOfBirth: Date = Date.now
    @Published var users: [UserData] = [UserData]()

    let roles = ["user", "admin"]
    let db = Firestore.firestore()
    
    func checkUserRole(projectId: String) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        print("projectId",projectId)
       
        db.collection("user_project").whereField("userDocumentId", isEqualTo: currentUser.uid).whereField("projectDocumentId", isEqualTo: projectId).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let document = snapshot?.documents.first, let role = document.get("role") as? String {
                    self.role = role
                } else {
                    print("doc not found12")
                    self.role = ""
                }
            }
        }
    }

    func doesUserExist(completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to check if user exists: \(error.localizedDescription)")
                    completion(false)
                } else if let methods = signInMethods, methods.isEmpty == false {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func addUserToProject(projectDocumentId: String) {
        doesUserExist{ userExists in
            if userExists {

                self.db.collection("users").whereField("email", isEqualTo: self.email).getDocuments { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                           for document in querySnapshot!.documents {
                               let userDocumentId = document.documentID
                               self.db.collection("user_project")
                                   .whereField("projectDocumentId", isEqualTo: projectDocumentId)
                                   .whereField("userDocumentId", isEqualTo: userDocumentId)
                                   .getDocuments { [self] (querySnapshot, err) in
                                       if let err = err {
                                           print("Error getting documents: \(err)")
                                       } else if querySnapshot!.documents.count > 0 {
                                           print("User is already in the project")
                                           self.showAddUserSheet = false
                                       } else {
                                           let userProjectData: [String: Any] = [
                                               "projectDocumentId": projectDocumentId,
                                               "role": self.role,
                                               "userDocumentId": userDocumentId
                                           ]
                                           self.db.collection("user_project").addDocument(data: userProjectData) { error in
                                               if let error = error {
                                                   print("Error adding user to project: \(error.localizedDescription)")
                                               } else {
                                                   print("User added to project successfully")
                                                   self.showAddUserSheet = false
                                               }
                                           }
                                       }
                                   }
                           }
                       }
                   }
               } else {
                print("User with email \(self.email) is not registered")
            }
        }
    }
    
func addNewUserToProject(projectDocumentId: String){
        let userData = UserData(name: name,
                                surname: surname,
                                dateOfBirth: dateOfBirth,
                                email: email)
        
        Auth.auth().createUser(withEmail: email, password: "123456") { authResult, error in
            
            guard let userAuthorized = authResult?.user, error == nil else {return}
            
            
            if let user = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let userDocRef = db.collection("users").document(user.uid)
                
                let userFirestoreData: [String: Any] = [
                    "name": userData.name,
                    "surname": userData.surname,
                    "dateOfBirth": userData.dateOfBirth,
                    "email": userData.email,
                ]
                
                userDocRef.setData(userFirestoreData) { error in
                    guard error == nil else{return}
                    
                    userAuthorized.sendEmailVerification{ error in
                        guard error == nil else{return}
                    }
                }
                
                self.addUserToProject(projectDocumentId: projectDocumentId)
                
                userAuthorized.sendEmailVerification{ error in
                    guard error == nil else{return}
                    
                    self.name = ""
                    self.surname = ""
                    self.dateOfBirth = Date.now
                    self.email = ""
                    self.showRegisterNewUserSheet = false
                }
            }
        }
    }
    
    func fetchProjectUsers(projectDocumentId: String) {
        users.removeAll()
            
            
            db.collection("user_project").whereField("projectDocumentId", isEqualTo: projectDocumentId)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let userDocumentId = document.data()["userDocumentId"] as! String
                            
                            self.db.collection("users").document(userDocumentId).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let data = document.data()
                                    let userData = UserData(
                                        name: data?["name"] as? String ?? "",
                                        surname: data?["surname"] as? String ?? "",
                                        dateOfBirth: (data?["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date.now,
                                        email: data?["email"] as? String ?? ""
                                    )
                                    DispatchQueue.main.async {
                                        self.users.append(userData)
                                    }
                                } else {
                                    print("Document does not exist")
                                }
                            }
                        }
                    }
                }
        }
    
    func deleteProject(projectId: String) {
        self.db.collection("projects").document(projectId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
