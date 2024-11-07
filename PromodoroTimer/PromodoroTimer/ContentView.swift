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
    @State private var selectedEmoji: String = "🐵"
    @State private var isTimerRunning = false
    @State private var elapsedTime = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 80) {
            Text(
                headPhoneManager.isHeadPhoneAuthorized ? "헤드폰 권한허용! 🎧" : "헤드폰 권한 미허용 😇"
            )

            Text(selectedEmoji) // 사용자가 선택한 이모지 표시
                            .font(.system(size: 150)) // 이모지 크기 설정
                            .rotation3DEffect(.radians(headPhoneManager.pitch), axis: (x: 1, y: 0, z: 0))
                            .rotation3DEffect(.radians(headPhoneManager.yaw), axis: (x: 0, y: 1, z: 0))
                            .rotation3DEffect(.radians(headPhoneManager.roll), axis: (x: 0, y: 0, z: 1))

            Text("타이머: \(elapsedTime)초")

            HStack {
                Button("시작!") {
                    headPhoneManager.calibrate()
                    headPhoneManager.startUpdates()
                    isTimerRunning = true
                }
                .buttonStyle(.bordered)

                Button("종료!") {
                    headPhoneManager.stopUpdates()
                    isTimerRunning = false
                    elapsedTime = 0
                }
                .buttonStyle(.bordered)
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                checkHeadphoneAngle()
            }
        }
        .padding()
    }

    private func checkHeadphoneAngle() {
        let threshold: Double = .pi / 8  

        if abs(headPhoneManager.pitch) < threshold &&
           abs(headPhoneManager.yaw) < threshold &&
           abs(headPhoneManager.roll) < threshold {
            isTimerRunning = true
            elapsedTime += 1
        } else {
            isTimerRunning = false
        }
    }
}

#Preview {
    ContentView()
}

