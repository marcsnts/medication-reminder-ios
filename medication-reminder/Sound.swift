//
//  Sound.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-22.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import AVFoundation

enum SoundType: SystemSoundID {
    case alarm = 1021,
    chime = 1007
}

class Sound {
    class func play(type: SoundType, repeats: Int?) {
        if let repeats = repeats {
            for _ in 0..<repeats {
                AudioServicesPlaySystemSound(type.rawValue)
            }
        }
        else {
            AudioServicesPlaySystemSound(type.rawValue)

        }
    }
}
