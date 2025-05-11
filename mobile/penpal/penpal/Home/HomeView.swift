//
//  HomeView.swift
//  penpal
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Text("Hello, World!")
                
                StdButton(label: "Disconnect", label_color: .white, background: .red ) {
                    KeychainHelper.shared.remove(service: "auth", account: "token")
                }
            }
        }
    }
}
