//
//  TimeManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-21.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class TimeManager: NSObject {
    struct StopWatch {
        var totalTime: Double = 0
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
    }

    var stopWatch = StopWatch()

    func addTime(timeInterval: TimeInterval) {
        stopWatch.totalTime += timeInterval
        stopWatch.hour = Int(stopWatch.totalTime)/3600
        stopWatch.minute = Int(stopWatch.totalTime)/60%60
        stopWatch.second = Int(stopWatch.totalTime)%60
    }
    
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if stopWatch.hour < 1 {
            dateFormatter.dateFormat = "mm:ss"
        }
        var dateComponents = DateComponents()
        dateComponents.hour = stopWatch.hour
        dateComponents.minute = stopWatch.minute
        dateComponents.second = stopWatch.second
        dateComponents.calendar = Calendar.current
        let date = dateFormatter.string(from: dateComponents.date!)
        return "\(date)"
    }
}
