//
//  SignUpView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/18/23.
//

import SwiftUI


struct SignUpView: View {
    @State var emailInput: String = ""
    @State var nameInput: String = ""
    @State var passwordInput: String = ""
    @State var passwordConfirm: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack (spacing: 20){
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 40)
                InputView(label: "Email Address", placeholder: "example@email.com", inputText: $emailInput)
                    .textInputAutocapitalization(.never)
                InputView(label: "Full Name", placeholder: "Enter your name", inputText: $nameInput)
                
                InputView(label: "Password", placeholder: "Enter your password", inputText: $passwordInput, isSecureField: true)
                    .textInputAutocapitalization(.never)
                ZStack(alignment: .trailing) {
                    InputView(label: "Confirm your password", placeholder: "Confirm your password", inputText: $passwordConfirm, isSecureField: true)
                        .textInputAutocapitalization(.never)
                    if !passwordInput.isEmpty && !passwordConfirm.isEmpty {
                        if passwordInput == passwordConfirm {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                                .padding(.horizontal, 10)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                                .padding(.horizontal, 10)
                        }
                    }
                }
                Button{
                    Task{
                        try await viewModel.createUser(withEmail:emailInput, password: passwordInput, fullName: nameInput)
                    }
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .navigationBarBackButtonHidden(true)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Already have an account? **Sign In**")
                        .foregroundStyle(primaryColor)
                }
            }
        }
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !emailInput.isEmpty && !passwordInput.isEmpty && !nameInput.isEmpty && emailInput.contains("@") && passwordInput.count > 5 && passwordInput == passwordConfirm
    }
}

#Preview {
    SignUpView(emailInput: "", nameInput: "", passwordInput: "", passwordConfirm: "")
}
