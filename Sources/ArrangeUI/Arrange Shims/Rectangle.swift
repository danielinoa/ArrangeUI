//
//  Created by Daniel Inoa on 1/4/24.
//

import CoreGraphics
import Arrange

public extension Rectangle {

  var asCGRect: CGRect {
    .init(x: x, y: y, width: width, height: height)
  }
}
