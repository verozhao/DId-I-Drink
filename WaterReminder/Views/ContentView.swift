//
//  ContentView.swift
//  WaterReminder
//
//  Created by veronica on 1/10/25.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var waterStore = WaterStore()
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 15)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(waterStore.glassCount) / 8.0)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: waterStore.glassCount)
                    
                    VStack {
                        Text("\(waterStore.glassCount)/8")
                            .font(.system(size: 40, weight: .bold))
                        Text("glasses")
                            .font(.system(size: 20))
                    }
                }
                
                // Add Water Button
                Button(action: {
                    waterStore.addGlass()
                    if waterStore.glassCount == 8 {
                        showingAlert = true
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "drop.fill")
                        Text("Add Glass")
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                // Today's Progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Progress")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<8) { index in
                            Circle()
                                .fill(index < waterStore.glassCount ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .animation(.spring(), value: waterStore.glassCount)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                // Reset Button (for testing)
                Button(action: {
                    waterStore.resetCount()
                }) {
                    Text("Reset Count (Debug)")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Did I Drink?")
            .alert("Daily Goal Achieved! 🎉", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Congratulations! You've reached your daily goal of 8 glasses!")
            }
        }
    }
}

// Preview Provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
