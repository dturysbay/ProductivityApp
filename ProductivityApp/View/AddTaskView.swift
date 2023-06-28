//
//  AddTaskView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 20.06.2023.
//
//
import SwiftUI

struct AddTaskView: View{
    let project: Project
    @EnvironmentObject var taskManagerController: TaskManagerController
    @Binding var isAddTaskSheetPresented: Bool
    @State var title: String = ""
    @State var description: String = ""
    @State var assignedTo: ProjectUser?
    @State var importanceStatus: String = "Important"
    @State var urgencyStatus: String = "Urgent"
    @State var kanbanStatus: String = "To Do"
    @State var deadline = Date.now
    
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
                   
                HStack {
                    CustomLabel(text: "Description")
                    Spacer()
                }

                TextEditor(text: $description)
                   .padding(4)
                   .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                   .frame(height: 100)
            }
            .padding(.horizontal,16)
            List{
                Group{
                    Picker("Assigned to", selection: $assignedTo) {
                        ForEach(taskManagerController.projectUsers, id: \.self) { projectUser in
                            Text("\(projectUser.name) \(projectUser.surname)").tag(projectUser as ProjectUser?)
                            }
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
                    
                    Picker("Urgency", selection: $urgencyStatus) {
                        Text("Urgent").tag("Urgent")
                        Text("Not Urgent").tag("Not Urgent")
                    }
                    
                    DatePicker("Deadline", selection: $deadline,displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "en"))
                }
            }
            .frame(height: 330)
            .listStyle(.plain)
            Spacer()
            Button{
                
                let newTask = Task(docId: "",
                                   projectDocumentId: project.id,
                                   assignedTo: assignedTo?.docId ?? "",
                                   createdBy: "",
                                   title: title,
                                   description: description,
                                   kanbanStatus: kanbanStatus,
                                   importanceStatus: importanceStatus,
                                   urgencyStatus: urgencyStatus,
                                   createdAt: Date.now,
                                   deadline: deadline)
                taskManagerController.addTask(newTask) {added in }
                isAddTaskSheetPresented = false
                taskManagerController.fetchTasks(forProject: project.id)
                taskManagerController.fetchTasksByMatrix(forProject: project.id)
            }label:{
                Text("Add task")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        
    }
}
