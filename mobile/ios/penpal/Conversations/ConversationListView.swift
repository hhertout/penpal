//
//  ConversationListView.swift
//  penpal
//

import SwiftUI

struct ConversationListView: View {
    var conversations: [ConversationModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(conversations) { conv in
                NavigationLink(
                    destination: MessagesView(
                        conversationId: conv._id,
                        name: conv.character.name
                    )
                ) {
                    HStack(alignment: .center) {
                        Avatar(name: conv.character.name)
                        Text(conv.character.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(.separator), lineWidth: 0.5)
                            .opacity(0.4)
                    )
                }
            }
            Spacer()
        }.padding(.vertical)
    }
}

#Preview {
    let jsonData = """
    [
        {
            "_id": "68299100dbca07a6ac9c33e6",
            "user_id": "6820723b64d186adcd3dd895",
            "name": "tony",
            "character": {
                "name": "Tony",
                "gender": "men",
                "city": "Melbourne",
                "country": "Australia"
            }
        },
        {
            "_id": "6829a37b47bb6afcc372ea9c",
            "user_id": "6820723b64d186adcd3dd895",
            "name": "",
            "character": {
                "name": "Robert",
                "gender": "Homme",
                "city": "Sydney",
                "country": "Australia"
            }
        }
    ]
    """.data(using: .utf8)
    
    let conversations = try! JSONDecoder().decode([ConversationModel].self, from: jsonData!)
    
    ConversationListView(conversations: conversations)
}
