//
//  Created by Daniel Inoa on 1/4/24.
//

import CoreGraphics
import Rectangular

public extension CGRect {

    var asRect: Rectangle {
        .init(x: minX, y: minY, width: width, height: height)
    }
}
