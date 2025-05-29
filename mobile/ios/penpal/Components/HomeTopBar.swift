//
//  HomeTopBar.swift
//  penpal
//

import SwiftUI

public struct HomeTopBar: View {
    @EnvironmentObject var session: Session

    public var body: some View {
        HStack {
            Spacer()
            Button {
                session.isLoggedIn = false
                session.user = nil

                KeychainHelper.shared.remove(
                    service: "auth",
                    account: "token"
                )
            } label: {
                HStack {
                    Image(
                        systemName: "rectangle.portrait.and.arrow.forward"
                    )
                    .foregroundColor(.red)
                    Text("Deconnexion")
                        .font(.caption).foregroundColor(.red)
                }
            }
        }
    }
}
