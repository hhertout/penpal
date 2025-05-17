//
//  Avatar.swift
//  penpal
//

import SwiftUI

struct Avatar: View {
    var name: String
    var diameter: CGFloat = 50

    var body: some View {
        let initial = String(name.prefix(1)).uppercased()

        Text(initial)
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: diameter, height: diameter)
            .background(Circle().fill(Color.gray))
    }
}
