//
//  TimerManager.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/8/23.
//
//
//

import SwiftUI

struct TimerManager: View {
    
    @State var timeRemaining = 60000
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        Text("\(formatter.string(from: TimeInterval(timeRemaining)) ?? "00:00:00")")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .foregroundColor(.white)
            .padding(.bottom, 5)
    }
}

struct Timer_Previews: PreviewProvider {
    static var previews: some View {
        TimerManager()
    }
}
