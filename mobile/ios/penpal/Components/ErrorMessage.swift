//
//  ErrorMessage.swift
//  penpal
//

import SwiftUI

struct ErrorMessage: View {
    var error: String?
    
    init(error: String?) {
        self.error = error
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Une erreur est suvenue...")
            Text("Merci de contacter l'administrateur du site...")
            if error != nil {
                Text("Message d'erreur: \(error!)")
            }
        }
            .foregroundColor(.red)
            .padding()
        
    }
}

#Preview {
    ErrorMessage(error: "Erreur au chargement des données...")
}
