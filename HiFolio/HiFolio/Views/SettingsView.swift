//
//  SettingsView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPresentingConfirm: Bool = false
    @State var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            HStack (alignment: .top){
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                   if viewModel.avatarImage != nil {
                        Image(uiImage: viewModel.avatarImage!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
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
                .padding(.trailing, 75)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 125)
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            
            Spacer()
            Link("Report Issue", destination: URL(string: "https://forms.gle/SaT617ASR7jbynnL7")!)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(.white)
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
            Button{
                viewModel.signOut()
            } label: {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(primaryColor)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            
            Button{
                isPresentingConfirm = true
            } label: {
                Text("DELETE ACCOUNT")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(destructiveColor)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
            .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                Button("Delete your Account?", role: .destructive) {
                    viewModel.deleteData()
                    viewModel.deleteAccount()
                }
            }
            
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem {
                    let data = try? await photosPickerItem.loadTransferable(type: Data.self)
                    if let data {
                        if let image = UIImage(data: data) {
                            viewModel.uploadPhoto(profileImage: image)
                            viewModel.avatarImage = image
                            Task {
                                await viewModel.updatePortfolio()
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct ChangeSheet: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State var emailInput: String = ""
//    @State var nameInput: String = ""
//    @EnvironmentObject var viewModel: AuthViewModel
//    
//    var body: some View {
//        VStack(alignment: .trailing) {
//            InputView(label: "Email Address", placeholder: viewModel.currentUser?.fullName ?? "nil", inputText: $emailInput)
//                .textInputAutocapitalization(.never)
//            InputView(label: "Full Name", placeholder: viewModel.currentUser?.fullName ?? "nil", inputText: $nameInput)
//            
//            
//            
//        }
//    }
//}

#Preview {
    SettingsView()
}
