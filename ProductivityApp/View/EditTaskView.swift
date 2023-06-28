//
//  EditTaskView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 22.06.2023.
//

import SwiftUI

struct EditTaskView: View{
    let project: Project
    @EnvironmentObject var taskManagerController: TaskManagerController
    @EnvironmentObject var projectData: ProjectViewController
    @Binding var selectedTask: Task?
    @Binding var isEditSheetPresented: Bool
    @State var title: String = ""
    @State var description: String = ""
    @State var createdBy: ProjectUser?
    @State var assignedTo: ProjectUser?
    @State var importanceStatus: String = ""
    @State var urgencyStatus: String = ""
    @State var kanbanStatus: String = ""
    @State var deadline = Date.now
    @State var createdDate = Date.now
    
    var body: some View{
        VStack{
            Group{
                HStack {
                    CustomLabel(text: "Title")
                    Spacer()
                }
                .padding(.top,30)

                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                    .placeholder(when: title.isEmpty) {
                        Text("Title")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .disabled(projectData.role == "user")
                HStack {
                    CustomLabel(text: "Description")
                    Spacer()
                }

                TextEditor(text: $description)
                   .padding(4)
                   .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                   .frame(height: 100)
                   .disabled(projectData.role == "user")
                
                HStack {
                    CustomLabel(text: "Info")
                    Spacer()
                }
            }
            .padding(.horizontal,16)
            
            Group{
                List{
                    Group{
                        Picker("Assigned to", selection: $assignedTo) {
                            ForEach(taskManagerController.projectUsers, id: \.self) { projectUser in
                                Text("\(projectUser.name) \(projectUser.surname)").tag(projectUser as ProjectUser?)
                                }
                        }
                        .disabled(projectData.role == "user")
                        
                        HStack {
                            Text("Created by")
                            Spacer()
                            Text("\(self.createdBy?.name ?? "") \(self.createdBy?.surname ?? "")")
                        }
                        HStack {
                            
                            Picker("Kanban Status", selection: $kanbanStatus) {
                                ForEach(taskManagerController.statuses, id: \.self) { status in
                                    Text(status).tag(status as String)
                                    }
                            }
                            
                        }
                        Picker("Importance", selection: $importanceStatus) {
                            Text("Important").tag("Important")
                            Text("Not Important").tag("Not Important")
                        }
                        .disabled(projectData.role == "user")
                        
                        Picker("Urgency", selection: $urgencyStatus) {
                            Text("Urgent").tag("Urgent")
                            Text("Not Urgent").tag("Not Urgent")
                        }
                        .disabled(projectData.role == "user")
                        
                        DatePicker("Created Date",selection:$createdDate,displayedComponents: .date)
                            .environment(\.locale, Locale(identifier: "en"))
                            .disabled(true)
                        DatePicker("Deadline", selection: $deadline,displayedComponents: .date)
                            .environment(\.locale, Locale(identifier: "en"))
                            .disabled(projectData.role == "user")
                    }
                }
                .frame(height: 330)
                .listStyle(.plain)
            }
            Button(action: {
                let editedTask = Task(docId: selectedTask?.docId ?? "", projectDocumentId: selectedTask?.projectDocumentId ?? "", assignedTo: assignedTo?.docId ?? "12", createdBy: createdBy?.docId ?? "12", title: title, description: description, kanbanStatus: kanbanStatus, importanceStatus: importanceStatus, urgencyStatus: urgencyStatus, createdAt: createdDate, deadline: deadline)
                taskManagerController.updateProjectById(task: editedTask, for: projectData.role)
                isEditSheetPresented = false
                taskManagerController.fetchTasks(forProject: project.id)
                
            }) {
                Text("Update task")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal,16)
            .padding(.top,10)
        }
        
        .onAppear {
            if let task = selectedTask {
                title = task.title
                description = task.description
                taskManagerController.fetchUserId(by: selectedTask?.createdBy ?? "") { createdBy in
                    self.createdBy = createdBy
                }
                taskManagerController.fetchUserId(by: selectedTask?.assignedTo ?? "") { assignedTo in
                    self.assignedTo = assignedTo
                }
                kanbanStatus = task.kanbanStatus
                importanceStatus = task.importanceStatus
                urgencyStatus = task.urgencyStatus
                createdDate = task.createdAt
                deadline = task.deadline
            }
        }
    }
}
