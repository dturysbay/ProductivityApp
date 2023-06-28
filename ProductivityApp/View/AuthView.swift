//
//  ContentView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 04.04.2023.
//

import SwiftUI

struct AuthView: View {
    
    init() {
        UIDatePicker.appearance().backgroundColor = UIColor.init(.white)
    }

    @StateObject private var authData = AuthenticationController()
    
    var body: some View {
        
        let loadingView = ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
                    .foregroundColor(.white)
                    .background(Color.white)
        

        switch authData.screenState {
        case .loginView:
            loginView
                .overlay(authData.isLoading ? loadingView : nil)
        case .signUpView:
            signUpView
                .overlay(authData.isLoading ? loadingView : nil)
        case .userAutorized:
            UserView()
                .environmentObject(authData)
                .tint(Color.mint)
        }
    }
        
    
    var loginView: some View {
        ZStack{
            backgroundView
            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40,weight: .bold,design: .rounded))
                    .offset(x:-100,y:-100)
                    .accessibility(identifier: "welcomeText")
                
                TextField("Email",text: $authData.email)
                    .autocorrectionDisabled(true)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                    .autocapitalization(.none)
                    .placeholder(when: authData.email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .accessibility(identifier: "emailTextField")
                
                Line()
                
                SecureField("Password",text: $authData.password)
                    .autocorrectionDisabled(true)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                    .autocapitalization(.none)
                    .placeholder(when: authData.password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .accessibility(identifier: "passwordTextField")
                
                Line()
                
                Button{
                    authData.login()
                }label: {
                    Text("Login")
                        .bold()
                        .frame(width: 200,height: 40)
                        .background {
                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                                .fill(.linearGradient(colors:[.pink,.red], startPoint: .top, endPoint: .bottomTrailing))
                        }
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)
                .accessibility(identifier: "loginButton")
                
                Button{
                    authData.screenState = .signUpView
                }label: {
                    Text("Register")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top)
                .offset(y: 110)
                .accessibility(identifier: "registerButton")
            }
            .frame(width: 350)
            
        }
        .alert(isPresented: $authData.isShowingAlert) {
            Alert(title: Text("Notification"), message: Text(authData.alertmessage), dismissButton: .default(Text("OK")){
                authData.isLoading = false
            })
        }
    }
    
    var signUpView: some View{
        ZStack{
            backgroundView
            VStack{
                VStack(spacing:20){
                    TextField("Name",text: $authData.name)
                        .autocorrectionDisabled(true)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .bold()
                        .autocapitalization(.none)
                        .placeholder(when: authData.name.isEmpty) {
                            Text("Name")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .accessibility(identifier: "nameTextField")
                    
                    Line()
                    
                    TextField("Surname",text: $authData.surname)
                        .autocorrectionDisabled(true)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .bold()
                        .autocapitalization(.none)
                        .placeholder(when: authData.surname.isEmpty) {
                            Text("Surname")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .accessibility(identifier: "surnameTextField")
                    
                    Line()
                    
                    DatePicker(selection: $authData.dateOfBirth, displayedComponents: .date) {
                                    Text("Date of Birth")
                                    .bold()
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                    }
                    .environment(\.locale, Locale(identifier: "en"))
                    
                    Line()
                    
                    TextField("Email",text: $authData.email)
                        .autocorrectionDisabled(true)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .bold()
                        .autocapitalization(.none)
                        .placeholder(when: authData.email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .accessibility(identifier: "emailTextField")
                    
                    Line()
                    
                    SecureField("Password",text: $authData.password)
                        .autocorrectionDisabled(true)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .bold()
                        .autocapitalization(.none)
                        .placeholder(when: authData.password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .accessibility(identifier: "passwordTextField")
                    
                    Line()
                }
                .frame(width: 350)
                
                Button{
                    authData.register()
                }label: {
                    Text("Register")
                        .bold()
                        .frame(width: 200,height: 40)
                        .background {
                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                                .fill(.linearGradient(colors:[.pink,.red], startPoint: .top, endPoint: .bottomTrailing))
                        }
                        .foregroundColor(.white)
                }
                .accessibility(identifier: "registerButton")
                .padding(.top)
                .offset(y: 20)
                
                Button{
                    authData.screenState = .loginView
                }label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top,32)
                
            }
        }
        .alert(isPresented: $authData.isShowingAlert) {
            Alert(title: Text("Notification"), message: Text(authData.alertmessage), dismissButton: .default(Text("OK")){
                authData.isLoading = false
            })
        }
    }
    
    var backgroundView: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30,style: .continuous)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow, Color.purple]), startPoint: .topLeading, endPoint: .bottom))
                .frame(width: 1000,height: 400)
                .rotationEffect(.degrees(135))
                .offset(y:-355)
        }
    }
}

