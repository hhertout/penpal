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
                }.padding(.horizontal, 24)

                ZStack {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Bienvenue !")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal, 6)
                            Spacer()
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
                .padding(.horizontal, 24)
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
