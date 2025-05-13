//
//  StdButton.swift
//  penpal
//


import SwiftUI

struct StdButton: View {
    let label: String
    let label_color: Color
    let background: Color
    let disabled: Bool
    let height: CGFloat = 50
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(background)

                Text(label)
                    .bold()
                    .foregroundColor(label_color)
            }
        }
        .frame(height: height)
        .disabled(disabled)
        .padding(1)
    }
}

struct StdButton_Previews: PreviewProvider {
    static var previews: some View {
        StdButton(label: "Test", label_color: .white, background: .blue, disabled: true) {
            // Action
        }
    }
}

