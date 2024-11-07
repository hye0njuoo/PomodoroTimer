//
//  HeadPhoneManager.swift
//  PromodoroTimer
//
//  Created by 성현주 on 11/7/24.
//

import Foundation
import CoreMotion

class HeadPhoneManager: ObservableObject {

    @Published var isHeadPhoneAuthorized = false
    var isTracking = false
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0

    private var initialPitch: Double = 0.0
    private var initialRoll: Double = 0.0
    private var initialYaw: Double = 0.0

    private let cmHeadPhoneManager = CMHeadphoneMotionManager()

    init() {
        updateAuthorization()
    }

    func startUpdates() {
        print("헤드폰 모션 추적을 시작합니다.")
        if isTracking {
            print("이미 헤드폰 모션을 추적중입니다.")
            return
        }

        isTracking = true

        cmHeadPhoneManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion, let self = self, error == nil else {
                print("HeadPhone CoreMotion에서 에러가 발생했습니다. error = ", error!.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                self.pitch = motion.attitude.pitch - self.initialPitch
                self.roll = motion.attitude.roll - self.initialRoll
                self.yaw = motion.attitude.yaw - self.initialYaw

                print("Pitch: \(self.pitch), Roll: \(self.roll), Yaw: \(self.yaw)")

            }
            
        }
    }

    func stopUpdates() {
        print("헤드폰 모션 추적을 중지합니다.")

        if !isTracking {
            print("이미 헤드폰 모션이 종료되었습니다.")
        }

        isTracking = false
        pitch = 0
        roll = 0
        yaw = 0
        cmHeadPhoneManager.stopDeviceMotionUpdates()
    }

    private func updateAuthorization() {
        switch CMHeadphoneMotionManager.authorizationStatus() {
        case .authorized:
            isHeadPhoneAuthorized = true
        case .denied:
            break
        case .notDetermined:
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }

    func calibrate() {
        initialPitch = pitch
        initialRoll = roll
        initialYaw = yaw
    }

    deinit {
        stopUpdates()
    }
}

