//
//  NoConnectionView.swift
//  penpal
//

import SwiftUI

struct NoConnectionView: View {
    var retryAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))

            Text("Pas de connexion")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Impossible de contacter le serveur pour le moment. Vérifiez votre connexion internet ou réessayez plus tard.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let retry = retryAction {
                Button(action: retry) {
                    Label("Réessayer", systemImage: "arrow.clockwise")
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NoConnectionView {
        //
    }
}
