//
//  TimeService.swift
//  B2S
//
//  Created by Egor Sakhabaev on 26.11.2021.
//

import Foundation

public class TimeService {
    private static var timer: Timer?
    
    public static func enableAutoSync() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
}

// MARK: - Private methods
extension TimeService {
    @objc private static func timerAction() {
        NotificationCenter.default.post(name: .init(rawValue: "didPassSecond"), object: nil)
    }
}
