//
//  UserList.swift
//  gHubChat
//
//  Created by Jahid Hassan on 10/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import SwiftUI

struct UserList: View {
    @ObservedObject var viewModel: InitialViewModel
    
    var body: some View {
        Group {
            if viewModel.isEmpty {
                LoadingView()
            } else {
                NavigationView {
                    List(viewModel.list) { user in
                        NavigationLink(destination: MessageView(viewModel: MessageViewModel(buddy: user))) {
                           UserRow(user: user)
                       }
                   }
                    .navigationBarTitle("")
                    .navigationBarItems(leading: Text("gHubChat"))
                }
            }
        }.onAppear {
            self.viewModel.loadData()
        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList(viewModel: InitialViewModel())
    }
}
