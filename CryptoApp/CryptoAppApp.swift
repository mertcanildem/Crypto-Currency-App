//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 12.11.2025.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        let accent = UIColor(Color.theme.accent)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : accent
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor : accent
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
