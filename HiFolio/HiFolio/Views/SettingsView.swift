//
//  SettingsView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
        VStack {
            HStack (alignment: .top){
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 80, height: 80)
                VStack {
                    Text(viewModel.currentUser?.fullName ?? "")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                    
                    Text(viewModel.currentUser?.emailAddress ?? "")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        .fontWeight(.light)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button{
                viewModel.signOut()
            } label: {
                Text("SIGN OUT")
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .foregroundColor(.cyan)
            }
            
            Button{
                isPresentingConfirm = true
            } label: {
                Text("DELETE ACCOUNT")
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .foregroundColor(.cyan)
            }
            .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                Button("Delete your Account?", role: .destructive) {
                    viewModel.deleteData()
                    viewModel.deleteAccount()
                }
            }
//            Button {
//                viewModel.deleteData()
//                viewModel.deleteAccount()
//            } label : {
//                Text("DELETE ACCOUNT")
//                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
//                    .foregroundStyle(.cyan)
//            }
        }
    }
}

#Preview {
    SettingsView()
}
