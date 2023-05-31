//
//  Created by Daniel Inoa on 5/11/23.
//

import UIKit

public struct PriorityGroup: Hashable {
    let priority: Int
    let views: [UIView]
}

public extension PriorityGroup {

    /// This function aggregates the specified arranged-views into groups based on their arrangement-priorities.
    static func grouping(views: [UIView]) -> [PriorityGroup] {
        var priorityTable: [Int: [UIView]] = [:]
        for view in views {
            if priorityTable[view.arrangementPriority] != nil {
                priorityTable[view.arrangementPriority]?.append(view)
            } else {
                priorityTable[view.arrangementPriority] = [view]
            }
        }
        return priorityTable.map(PriorityGroup.init)
    }
}
