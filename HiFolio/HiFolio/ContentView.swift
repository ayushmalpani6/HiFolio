//
//  ContentView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/17/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.userSession != nil {
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
