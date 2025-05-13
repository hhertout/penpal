//
//  VocabularyView.swift
//  penpal
//

import SwiftUI

struct VocabularyView: View {
    @StateObject var viewModel = VocubularyViewModel()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray)
            
            VStack {
                Text("Vocabulary Card")
            }
            .foregroundColor(.white)
        }
        
    }
}

#Preview {
    VocabularyView()
}
