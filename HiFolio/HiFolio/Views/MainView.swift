//
//  MainView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/19/23.
//
//123456

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        TabView {
            PortfolioView()
                .tabItem {
                    Label("Portfolio", systemImage: "folder.fill.badge.person.crop")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
        }
    }
}

#Preview {
    MainView()
}
