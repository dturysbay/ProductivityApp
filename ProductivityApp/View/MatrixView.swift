//
//  MatrixView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 10.06.2023.
//

import SwiftUI

struct MatrixView: View {
    let project: Project
    @EnvironmentObject var taskManagerController: TaskManagerController
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack{
                List{
                    ForEach(taskManagerController.tasksByMatrix, id: \.self) { task in
                        Section(header: Text(task.status)) {
                            ForEach(task.tasks, id: \.self) { projTask in
                                Text(projTask.title)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .foregroundColor(Color.mint)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .padding(.top,70)
        }
        .onAppear{
            taskManagerController.fetchTasksByMatrix(forProject: project.id)
        }
    }
}
