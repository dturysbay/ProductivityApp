//
//  AuthenticationController.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 04.04.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class AuthenticationController: ObservableObject{
    
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertmessage: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var screenState: ScreenState = .loginView
    @Published var isLoading: Bool = false
    
    func register() {
        isLoading = true
            let userData = UserData(name: name,
                                    surname: surname,
                                    dateOfBirth: dateOfBirth,
                                    email: email)
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                guard let userAuthorized = authResult?.user, error == nil else {
                    self.alertmessage = "Registration failed: " + (error?.localizedDescription ?? "Unknown Error")
                    self.isShowingAlert = true
                    
                    return
                }
                
                
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
                        guard error == nil else{
                            self.alertmessage = "Failed to save user data: \(error?.localizedDescription ?? "Unknown Error")"
                            self.isShowingAlert = true
                            
                            return
                        }
                        
                        userAuthorized.sendEmailVerification{ error in
                            guard error == nil else{
                                self.alertmessage = error?.localizedDescription ?? "Unknown Error"
                                self.isShowingAlert = true
                                
                                return
                            }
                        }
                            
                        self.alertmessage = "User registered successfully! Please check your email"
                        self.isShowingAlert = true
                        self.screenState = .loginView
                        
                        self.name = ""
                        self.surname = ""
                        self.dateOfBirth = Date.now
                        self.password = ""
                    }
                }
            }
        isLoading = false
        }
        
    func login() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user, error == nil else{
                self.alertmessage = error?.localizedDescription ?? "Unknown Error"
                self.isShowingAlert = true
                
                return
            }
           
            guard user.isEmailVerified else {
                self.alertmessage = "Verification email has been sent. Please check your email."
                self.isShowingAlert = true
                
                return
            }
            
            self.screenState = .userAutorized
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.screenState = .loginView
                self.isLoading = false
                self.password = ""
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func doesUserExist(email: String, completion: @escaping (Bool) -> Void) {
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
}

