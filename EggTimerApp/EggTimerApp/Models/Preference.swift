//
//  Preference.swift
//  EggTimerApp
//
//  Created by wx on 2021/6/28.
//

import Foundation

struct Preference {
    var selectedTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            return 360
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedTime")
        }
    }
}
