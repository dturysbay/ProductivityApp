//
//  ProjectDetailView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 10.06.2023.
//

import SwiftUI

struct ProjectView: View{
    let project: Project
    @State private var selectedTab: ProjectViewState = .kanban
    @StateObject private var projectData: ProjectViewController = ProjectViewController()
    @StateObject var taskManagerController = TaskManagerController()
    
    var body: some View{
        TabView(selection: $selectedTab){
            KanbanView(project: project)
                .environmentObject(projectData)
                .environmentObject(taskManagerController)
                .tabItem{
                    Label("Kanban",systemImage: "list.bullet.rectangle")
                }
                .tag(ProjectViewState.kanban)
            MatrixView(project: project)
                .environmentObject(taskManagerController)
                .tabItem{
                    Label("Matrix",systemImage: "camera.metering.matrix")
                }
                .tag(ProjectViewState.matrix)
            PomodoroView()
                .tabItem {
                    Label("Pomodoro",systemImage: "timer")
                }
        }
        .tint(Color.mint)
        .onAppear{
            projectData.fetchProjectUsers(projectDocumentId: project.id)
            projectData.checkUserRole(projectId: project.id)
        }
        .navigationBarTitle(project.title,displayMode: .inline)
        .navigationBarItems(trailing:
            NavigationLink(
                destination: ProjectInfoView(project: project)
                    .environmentObject(projectData)
                
            ) {
                Image(systemName: "doc")
            }
        )
    }
}
