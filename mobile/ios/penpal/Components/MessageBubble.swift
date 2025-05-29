//
//  MessageBubble.swift
//  penpal
//

import SwiftUI

struct MessageBubble: View {
    let message: String
    let isSentByCurrentUser: Bool

    var body: some View {
        HStack {
            HStack {
                if isSentByCurrentUser {
                    Spacer()
                }


                Text(message)
                    .padding(12)
                    .background(isSentByCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isSentByCurrentUser ? .white : .black)
                    .modifier(RoundedCornerModifier(radius: 16, corners: isSentByCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topRight, .topLeft, .bottomRight]))
                    .frame(maxWidth: 250, alignment: isSentByCurrentUser ? .trailing : .leading)
                    .padding(isSentByCurrentUser ? .trailing : .leading, 10)
                    .padding(.vertical, 4)

                if !isSentByCurrentUser {
                    Spacer()
                }
            }
        }
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct RoundedCornerModifier: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

#Preview {
    MessageBubble(message: "Hello, how are you ? I'm fine and you", isSentByCurrentUser: false)
}
