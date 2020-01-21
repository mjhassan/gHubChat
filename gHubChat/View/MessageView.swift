//
//  MessageView.swift
//  gHubChat
//
//  Created by Jahid Hassan on 10/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    let viewModel: MessageViewModelProtocol
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(viewModel: MessageViewModel(buddy: User(login: "name", id: 0, avatar_url: "http")))
    }
}
