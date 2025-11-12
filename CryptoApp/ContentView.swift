//
//  ContentView.swift
//  CryptoApp
//
//  Created by Mert can Ildem on 12.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondary Text Color")
                    .foregroundColor(Color.secondaryText)
                
                Text("Red Color")
                    .foregroundColor(Color.red)
                
                Text("Green Color")
                    .foregroundColor(Color.green)
            }
            .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
