//
//  Created by Daniel Inoa on 7/13/24.
//

import UIKit

public protocol Hook: Arranged {
    func viewWillBeAddedToArrangedTree(_ view: UIView)
}
