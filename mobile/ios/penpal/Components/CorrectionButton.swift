//
//  CorrectionButton.swift
//  penpal
//

import SwiftUI

struct CorrectionButton: View {
    var correction: String

    @State private var showModal = false

    var body: some View {
        VStack {
            Image(
                systemName: "graduationcap.circle.fill"
            )
            .resizable()
            .frame(width: 36, height: 36)
            .foregroundColor(.mint)
            .onTapGesture {
                showModal = true
            }
        }
        .sheet(isPresented: $showModal) {
            VStack {
                Text("Correction")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical, 32)
                    .foregroundColor(.mint)
            }
            
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Teacher")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(correction)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .padding(.horizontal)


                }
            }.padding()
            
            VStack {
                Button("Got it !") {
                    showModal = false
                }
                .padding()
            }
        }
    }
}

#Preview {
    CorrectionButton(correction: "Your message looks great! It's already correct:\n\n\n\"Hello, how are you?\"\n\nFeel free to ask if there's anything else I can assist with in French (or English)! Just let me know what you're interested in or need help with today. I'm here for it! 😊")
}
