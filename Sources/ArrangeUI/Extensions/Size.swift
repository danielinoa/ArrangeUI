//
//  Created by Daniel Inoa on 1/4/24.
//

import CoreGraphics
import Rectangular

public extension Size {

    var asCGSize: CGSize {
        .init(width: width, height: height)
    }
}
