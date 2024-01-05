//
//  Created by Daniel Inoa on 1/4/24.
//

import CoreGraphics
import Rectangular

extension CGRect {

    var asRect: Rectangle {
        .init(x: minX, y: minY, width: width, height: height)
    }
}
