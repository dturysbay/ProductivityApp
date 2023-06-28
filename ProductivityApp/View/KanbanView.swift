//
//  KanbanView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 10.06.2023.
//
import SwiftUI
import UIKit

struct KanbanView: View{

    let project: Project
    @EnvironmentObject var projectData: ProjectViewController
    @StateObject var taskManagerController = TaskManagerController()
    @State var selectedTask: Task?
    @State var isAssigned: Bool = false
    @State var isEditSheetPresented: Bool = false
    @State var isAddTaskSheetPresented: Bool = false
    var body: some View{
        VStack{
            List {
                  ForEach(taskManagerController.tasks, id: \.self) { task in
                      Section(header: Text(task.status)) {
                          ForEach(task.tasks, id: \.self) { projTask in
                              TaskRowView(
                                  isEditSheetPresented: $isEditSheetPresented,
                                  isAddTaskSheetPresented:$isAddTaskSheetPresented,
                                  selectedTask: $selectedTask, projTask: projTask)
                                  .environmentObject(taskManagerController)
                                  .environmentObject(projectData)
                          }
                      }
                      .foregroundColor(Color.mint)
                      
                  }
              }
              .listStyle(PlainListStyle())
              .background(Color.clear)
                
                Group{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            isAddTaskSheetPresented = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .frame(width: 56, height: 56)
                                .background(Color.mint)
                                .foregroundColor(.white)
                                .cornerRadius(28)
                        }
                    }
                    .padding()
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .sheet(isPresented: $isEditSheetPresented) {
                EditTaskView(project:project,selectedTask: $selectedTask,isEditSheetPresented:$isEditSheetPresented)
                    .environmentObject(taskManagerController)
            }
            .sheet(isPresented:$isAddTaskSheetPresented){
                AddTaskView(project: project,isAddTaskSheetPresented:$isAddTaskSheetPresented)
                    .environmentObject(taskManagerController)
            }
            .onAppear{
                taskManagerController.fetchProjectUsers(projectDocumentId: project.id)
                taskManagerController.fetchTasks(forProject:project.id)
            }
        }
    }
