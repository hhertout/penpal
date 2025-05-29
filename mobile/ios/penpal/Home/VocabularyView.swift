//
//  VocabularyView.swift
//  penpal
//

import SwiftUI

struct VocabularyView: View {
    @StateObject var viewModel = VocubularyViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                ProgressView()
                    .foregroundColor(.white)
            } else if viewModel.errorMessage != nil {
                ErrorMessage(error: viewModel.errorMessage)
            } else {
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text("Vocabulaire du jour")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("Français")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Anglais")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Divider()
                            .background(.white)

                        ForEach(viewModel.dailyVocabulary) { vocabulary in
                            HStack {
                                HStack {
                                    Text(vocabulary.fr)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(vocabulary.en)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Theme.Primary)
        )
        .task {
            await viewModel.getDailyVocabulary()
        }
    }
}

#Preview {
    VocabularyView()
}
