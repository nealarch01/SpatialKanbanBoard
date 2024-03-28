//
//  KanbanList.swift
//  SpatialKanbanPOC
//
//  Created by Neal Archival on 3/23/24.
//

import Foundation

struct KanbanList: Codable {
    var title: String
    let id: UUID
    
    init(title: String, id: UUID = UUID()) {
        self.title = title
        self.id = id
    }
}
