//
//  HomeBottomBar.swift
//  penpal
//

import SwiftUI

public struct HomeBottomBar: View {
    public var body: some View {
        HStack {
            Button {
                // Action
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.blue)

                    HStack {
                        Image(
                            systemName: "ellipsis.message.fill"
                        )
                        .foregroundColor(.white)
                        Text("Mes conversations")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 52)
            }
        }
    }
}

#Preview {
    HomeBottomBar()
}
