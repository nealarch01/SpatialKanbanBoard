//
//  KanbanListView.swift
//  SpatialKanbanPOC
//
//  Created by Neal Archival on 3/22/24.
//

import SwiftUI
import UIKit

// MARK: TicketView
//
private struct TicketView: View {
    let text: String
    
    var body: some View {
        Button(action: {}) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.tertiaryLabel))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonBorderShape(.roundedRectangle(radius: 16))
        .buttonStyle(.plain)
    }
}

// MARK: KanbanListView
//
struct KanbanListView: View {
    let list: KanbanList
    let tickets: [Ticket]
    let dropAction: (Ticket, KanbanList) -> Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(list.title)
                .font(.largeTitle)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(tickets, id: \.id) { ticket in
                        TicketView(text: ticket.text)
                            .draggable(ticket)
                    }
                }
                .padding()
            }
            .frame(width: 275)
            .background(Color(UIColor.secondaryLabel).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .dropDestination(for: Ticket.self) { items, location in
                guard let ticket = items.first else { return false }
                return dropAction(ticket, list)
            }
        }
    }
}

#Preview {
    HStack {
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(UIColor.systemBackground))
    .padding(.vertical)
}
