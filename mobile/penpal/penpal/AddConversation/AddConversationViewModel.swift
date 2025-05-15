//
//  AddConversationViewModel.swift
//  penpal
//

import Foundation

class AddConversationViewModel: ObservableObject {
    @Published var model: AddConversationModel = .init()
    
    init() {
        
    }
    
    @MainActor
    func addConversation() async {
        
    }
}
