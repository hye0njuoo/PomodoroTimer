//
//  MainView.swift
//  PromodoroTimer
//
//  Created by 성현주 on 11/7/24.
//

import SwiftUI

struct MainView: View {

    @State var tab = 0

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "headphones")
                    Text("Headphone")
                }
        }
    }
}

#Preview {
    MainView(tab: 0)
}

