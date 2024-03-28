//
//  Ticket.swift
//  SpatialKanbanPOC
//
//  Created by Neal Archival on 3/23/24.
//

import Foundation
import SwiftUI

struct Ticket: Codable {
    var text: String
    
    var id: UUID = UUID()
    var listID: UUID? = nil
    
    init(text: String, id: UUID = UUID(), listID: UUID? = nil) {
        self.text = text
        self.id = id
        self.listID = listID
    }
    
    mutating func assignToList(withID: UUID) {
        self.listID = withID
    }
    
    mutating func unassignList() {
        self.listID = nil
    }
}

extension Ticket: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
}
