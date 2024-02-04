//
//  SettingsView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPresentingConfirm: Bool = false
    @State var avatarImage: UIImage?
    @State var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            HStack (alignment: .top){
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .frame(width: 80, height: 80)
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                }
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
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            
            if avatarImage != nil {
                Button {
                    uploadPhoto()
                } label: {
                    Text("Confirm Profile Picture")
                }
            }
            Spacer()
            
            Button{
                viewModel.signOut()
            } label: {
                Text("SIGN OUT")
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .foregroundColor(primaryColor)
            }
            
            Button{
                isPresentingConfirm = true
            } label: {
                Text("DELETE ACCOUNT")
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .foregroundColor(primaryColor)
            }
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
                            avatarImage = image
                        }
                    }
                }
            }
        }
    }
    
    func uploadPhoto() {
        let storageRef = Storage.storage().reference()
        let imageData = avatarImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let fileRef = storageRef.child("Images/\(viewModel.currentUser!.id).jpeg")
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error != nil && metadata != nil{
                viewModel.currentUser?.profilePicture = "Images/\(viewModel.currentUser!.id).jpeg"
                Task {
                    await viewModel.updatePortfolio()
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
