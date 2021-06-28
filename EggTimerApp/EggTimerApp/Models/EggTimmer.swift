//
//  EggTimmer.swift
//  EggTimerApp
//
//  Created by wx on 2021/6/28.
//

import Foundation

protocol EggTimerProtocol {
    func timeRemainingOnTimer(_ timmer: EggTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: EggTimer)
}

class EggTimer {
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = Preference().selectedTime
    var elaspsedTime: TimeInterval = 0
    var isStopped: Bool {
        return timer == nil && elaspsedTime == 0
    }
    var isPaused: Bool {
        return timer == nil && elaspsedTime > 0
    }
    
//    init(duration d: TimeInterval) {
//        self.duration = d
//    }
    
    var delegate: EggTimerProtocol?
    
    @objc dynamic func timerAction() {
        guard let startTime = startTime else {
            return
        }
        
        elaspsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = (duration - elaspsedTime).rounded()
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elaspsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elaspsedTime)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerAction()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        duration = Preference().selectedTime
        elaspsedTime = 0
        timerAction()
    }
}

