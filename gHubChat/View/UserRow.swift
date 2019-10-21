//
//  UserRow.swift
//  gHubChat
//
//  Created by Jahid Hassan on 10/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import SwiftUI

struct UserRow: View {
    let user: User
    private let defaultMessage = "Hi there! I'm using gHubChat."
    
    var body: some View {
        return HStack {
            Image(uiImage: UIImage(named: "placeholder")!)
                .frame(width: 50.0, height: 50.0)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .shadow(radius: 10)
            
            VStack(alignment: .leading) {
                Text(user.login)
                Text(Store.shared.lastMessage(for: user.id) ?? defaultMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(0)
            }
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: User(login: "Name", id: 0, avatar_url: "hello"))
    }
}
