//
//  HiFolioApp.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/17/23.
//

import SwiftUI
import Firebase

@main
struct HiFolioApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
