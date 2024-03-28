//
//  ContentView.swift
//  SpatialKanbanPOC
//
//  Created by Neal Archival on 3/22/24.
//

import SwiftUI
import UIKit
import RealityKit

@MainActor
class KanbanViewModel: ObservableObject {
    @Published private(set) var lists: [KanbanList] = []
    @Published private(set) var tickets: [Ticket] = []
    
    init() {
        let todo = KanbanList(title: "Todo")
        let inProgress = KanbanList(title: "In Progress")
        let completed = KanbanList(title: "Complete")
        
        // Todo Tickets
        tickets.append(contentsOf: [
            Ticket(text: "Implement app persistence with SwiftData", listID: todo.id),
            Ticket(text: "Learn Uniform Type Identifiers", listID: todo.id),
            Ticket(text: "Add multiple boards feature", listID: todo.id)
        ])
        
        // In Progress Tickets
        tickets.append(contentsOf: [
            Ticket(text: "Implement drag and drop", listID: inProgress.id),
            Ticket(text: "Create initial commit", listID: inProgress.id)
        ])
        
        // Completed Tickets
        tickets.append(
            contentsOf: [Ticket(text: "Create Xcode project", listID: completed.id)]
        )
        
        lists.append(todo)
        lists.append(inProgress)
        lists.append(completed)
    }
    
    func moveTicket(ticket: Ticket, destinationList: KanbanList) -> Bool {
//        print("DEBUG - Running on main thread \(Thread.isMainThread)")
        let ticketID = ticket.id
        let destinationListID = destinationList.id
        
        guard let index = tickets.firstIndex(where: { $0.id == ticketID }) else { return false }
        if tickets[index].listID == destinationListID { return false } // No need to move the ticket if it is already in the destination list.
        
        // Update the ticket and it to the bottom of the list (bit of a hack).
        var updatedTicket = tickets.remove(at: index)
        updatedTicket.assignToList(withID: destinationListID)
        tickets.append(updatedTicket)
        
        objectWillChange.send()
        
        return true
    }
    
    func tickets(withListID listID: UUID) -> [Ticket] {
        self.tickets.filter { $0.listID == listID }
    }
}

struct ContentView: View {
    @StateObject var kanbanViewModel = KanbanViewModel()
    
    var body: some View {
        LazyHStack(spacing: 12) {
            ForEach(Array(kanbanViewModel.lists.enumerated()), id: \.offset) { index, list in
                KanbanListView(
                    list: list,
                    tickets: kanbanViewModel.tickets(withListID: list.id),
                    dropAction: dropAction // Note: Passing the ViewModel method directly causes it to lose `@MainActor`
                )
            }
        }
        .padding(.vertical)
    }
    
    func dropAction(ticket: Ticket, list: KanbanList) -> Bool {
        kanbanViewModel.moveTicket(ticket: ticket, destinationList: list)
    }
}

#Preview(windowStyle: .plain) {
    ContentView()
}
