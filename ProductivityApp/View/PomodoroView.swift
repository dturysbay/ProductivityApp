//
//  PomodoroView.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 23.06.2023.
//

import SwiftUI

struct PomodoroStorage{
    @AppStorage(StorageStates.focusValue.rawValue) static var focusName: FocusCategory = .work
}

struct PomodoroView: View{
    @State private var focusCategory: FocusCategory
    init(){
        focusCategory = PomodoroStorage.focusName
    }
    
    @State var isChangeFocusSheetShown: Bool = false
    
    @State
    private var progress: CGFloat = 0.2
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
            VStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 70, style: .continuous)
                        .fill(.white.opacity(0.3))
                       .frame(width: 170, height: 36)
                       .padding(.bottom,50)
                                   
                    HStack{
                        Group{
                            Image(systemName: "pencil")
                            Text(PomodoroStorage.focusName.rawValue.capitalized)
                        }
                        .font(.system(size: 16,weight: .bold))
                        .foregroundColor(.white)
                        .offset(y:-25)
                        .onTapGesture {
                            isChangeFocusSheetShown.toggle()
                        }
                    }
                }
            
                ZStack{
                    TimerViewSample()
                }.padding(.bottom,60)
                Spacer()
                Spacer()
            }
        }
        .sheet(isPresented: $isChangeFocusSheetShown) {
            ChangeFocusSheet(isChangeFocusSheetShown: $isChangeFocusSheetShown,
                focusCategory: $focusCategory)
                .presentationDetents([.fraction(0.43)])
                .presentationDragIndicator(.hidden)
        }
       
    }
}
