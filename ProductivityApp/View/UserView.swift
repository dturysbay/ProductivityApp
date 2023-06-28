//
//  UserView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 04.04.2023.
//

import SwiftUI

struct UserView: View {
    @StateObject var userController = UserViewController()
    @EnvironmentObject var authData: AuthenticationController
    var body: some View {
        NavigationView {
            VStack {
                List(userController.projects) { project in
                    NavigationLink(destination: ProjectView(project: project)) {
                        Text(project.title)
                            .foregroundColor(Color.black)
                    }
                    .tint(Color.mint)
                    
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)

                Button {userController.showSheet.toggle()} label: {
                    Text("Add Project")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(.bottom,16)
                .padding(.horizontal,16)
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .alert(isPresented: $userController.isShowingAlert) {
                Alert(title: Text("Notification"), message: Text(userController.alertmessage), dismissButton: .default(Text("OK")))
            }
            .environmentObject(userController)
            .navigationBarTitle("Projects",displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                authData.logout()
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
                }
            )
            .sheet(isPresented:$userController.showSheet){
                addProjectSheet
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.hidden)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }


    var addProjectSheet: some View{
        VStack {
            HStack {
                Spacer()
                Button {
                    userController.showSheet = false
                    userController.title = ""
                    userController.description = ""
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
                    Text("Project Title")
                            .font(.headline)
                    TextField("Enter new project title", text: $userController.title)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                VStack(alignment: .leading) {
                    Text("Project Description")
                          .font(.headline)
                    TextEditor(text: $userController.description)
                        .autocorrectionDisabled(true)
                        .frame(height: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                }
                Button {
                    userController.addProject()
                } label: {
                    Text("Add Project")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            Spacer()
        }
        .background(Color.teal.opacity(0.2).ignoresSafeArea())
        .interactiveDismissDisabled(userController.showSheet)

    }
}
