//
//  HomeView.swift
//  penpal
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    HomeTopBar()
                }

                ZStack {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Bienvenue")
                                .font(.largeTitle)
                        }
                        
                        HStack {
                            VStack {
                                VocabularyView()
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    HomeBottomBar()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    HomeView()
}
