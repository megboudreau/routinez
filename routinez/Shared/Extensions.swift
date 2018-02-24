//
//  Extensions.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-23.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

extension Int {
  var second: TimeInterval {
    return TimeInterval(self)
  }

  var seconds: TimeInterval {
    return TimeInterval(self)  }

  var minute: TimeInterval {
    return TimeInterval(self * 60)
  }

  var minutes: TimeInterval {
    return self.minute
  }

  var hour: TimeInterval {
    return TimeInterval(self * 60 * 60)
  }

  var hours: TimeInterval {
    return self.hour
  }

  var day: TimeInterval {
    return TimeInterval(self * 60 * 60 * 24)
  }

  var days: TimeInterval {
    return self.day
  }
}
