//
//  ContentView.swift
//  SimpleIntervalTimer
//
//  Created by Robin Börjesson on 2024-01-07.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("03:00")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Gauge(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, in: /*@START_MENU_TOKEN@*/0...1/*@END_MENU_TOKEN@*/) {}
                .padding(.horizontal, 50)
        }
        .padding()
    }
}

#Preview {
    MainView()
}
