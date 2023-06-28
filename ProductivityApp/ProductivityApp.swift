//
//  ProductivityAppApp.swift
//  ProductivityApp
//
//  Created by Dinmukhambet Turysbay on 04.04.2023.
//

import SwiftUI
import Firebase

@main
struct ProductivityApp: App {
    init(){
        FirebaseApp.configure()
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
