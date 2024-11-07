//
//  DeviceCoreMotionManager.swift
//  PromodoroTimer
//
//  Created by 성현주 on 11/7/24.
//

import Foundation
import CoreMotion

class DeviceCoreMotionManager: ObservableObject {

    private let cmManager = CMMotionManager()

    var isDeviceAvailable = false

    @Published var upOffset = -0.5

    init() {
        checkAuthorization()
        startUpdates()
    }

    private func checkAuthorization() {
        if cmManager.isDeviceMotionAvailable {
            self.isDeviceAvailable = true
        }
    }

    func startUpdates() {
        cmManager.accelerometerUpdateInterval = 0.1
        cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, error in
            if error != nil {
                print(#file, #function, error)
                return
            }

            guard let self = self else { return }

            if let acceleration = data?.acceleration {
                let zAcceleration = acceleration.z

                print(zAcceleration)

            }
        }
    }
}

