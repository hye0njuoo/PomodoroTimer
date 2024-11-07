//
//  ContentView.swift
//  PromodoroTimer
//
//  Created by 성현주 on 11/7/24.
//

import SwiftUI
import CoreMotion
import SceneKit

struct ContentView: View {

    @StateObject var headPhoneManager = HeadPhoneManager()

    init() {
    }

    var body: some View {
        VStack(spacing: 80) {
            Text(
                headPhoneManager.isHeadPhoneAuthorized ? "헤드폰 권한허용! 🎧" : "헤드폰 권한 미허용 😇"
            )

            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 200)
                .rotation3DEffect(
                    .radians(headPhoneManager.pitch),
                    axis: (x: 1, y: 0, z: 0)
                )
                .rotation3DEffect(
                    .radians(headPhoneManager.yaw),
                    axis: (x: 0, y: 1, z: 0)
                )
                .rotation3DEffect(
                    .radians(headPhoneManager.roll),
                    axis: (x: 0, y: 0, z: 1)
                )

            HStack {
                Button("시작!") {
                    headPhoneManager.calibrate()
                    headPhoneManager.startUpdates()
                }
                .buttonStyle(.bordered)

                Button("종료!") {
                    headPhoneManager.stopUpdates()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

