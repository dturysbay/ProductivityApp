//
//  ProjectInfoView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 10.06.2023.
//

import SwiftUI

struct ProjectInfoView: View {
    let project: Project

    @EnvironmentObject var authData: AuthenticationController
    @EnvironmentObject var projectData: ProjectViewController
    @State private var showingAlert = false
    var body: some View {
        VStack{
            List {
                ForEach(Array(projectData.users.enumerated()), id: \.offset) { index, user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(user.name) \(user.surname)")
                            Text(user.email)
                        }
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)

            Group{
                if projectData.role == "owner"{
                    Button("Add user") {
                        projectData.showAddUserSheet = true
                    }
//                    Button(action: {
//                        showingAlert = true
//                    }) {
//                        Text("Delete Project")
//                            .font(.title)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(25)
//                            .shadow(color: .gray, radius: 3)
//                    }
                }
            }
        }
        .onAppear {

        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("Are you sure you want to delete this project?"),
                primaryButton: .destructive(Text("Delete")) {
                    projectData.deleteProject(projectId: project.id)
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $projectData.showAddUserSheet) {
            addUserSheet
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.hidden)
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $projectData.showRegisterNewUserSheet, content: {
            registerNewUserSheet
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.hidden)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeIn, value: 0.5)
        })
        .navigationBarTitle("Project Info",displayMode: .inline)
    }
    
    var registerNewUserSheet: some View{
        VStack{
            HStack {
                Text(" User does not exist,\n please register the user")
                        .font(.headline)
                Spacer()
                Button {
                    projectData.showRegisterNewUserSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding(.top,32)
            
            VStack(alignment:.leading){
                Text("Name")
                        .font(.headline)
                TextField("Name", text: $projectData.name)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .placeholder(when: projectData.name.isEmpty) {
                        Text("Name")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                
                Text("Surname")
                        .font(.headline)
                TextField("Surname", text: $projectData.surname)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .placeholder(when: projectData.surname.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
               
                DatePicker(selection: $authData.dateOfBirth, displayedComponents: .date) {
                                Text("Date of Birth")
                                .bold()
                                .foregroundColor(.black)
                }
                .padding()
                .environment(\.locale, Locale(identifier: "en"))
                
                Text("Email")
                        .font(.headline)
                TextField("Email", text: $projectData.email)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .placeholder(when: projectData.email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                
                Text("Select role")
                        .font(.headline)
                Picker("Role", selection: $projectData.role) {
                    ForEach(projectData.roles, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            Button{
                projectData.addNewUserToProject(projectDocumentId: project.id)
            }label: {
                Text("Register user")
            }
        }
        .padding()
        .interactiveDismissDisabled(projectData.showRegisterNewUserSheet)
        .animation(.easeIn, value: 0.5)
        
    }
    
    var addUserSheet: some View{
        VStack {
            HStack {
                Spacer()
                Button {
                    projectData.showAddUserSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding(.top,32)
            Spacer()
            VStack {
                VStack(alignment: .leading) {
                    Text("Email")
                            .font(.headline)
                    TextField("Enter email", text: $projectData.email)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .placeholder(when: projectData.email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    Text("Select role")
                            .font(.headline)
                    Picker("Role", selection: $projectData.role) {
                        ForEach(projectData.roles, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                Button {
                    projectData.doesUserExist { userExists in
                        if userExists{
                            projectData.addUserToProject( projectDocumentId: project.id)
                        }else{
                            projectData.showAddUserSheet = false
                            projectData.showRegisterNewUserSheet = true
                        }
                    }
                } label: {
                    Text("Add User")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            Spacer()
        }
        .interactiveDismissDisabled(projectData.showAddUserSheet)
    }
}
