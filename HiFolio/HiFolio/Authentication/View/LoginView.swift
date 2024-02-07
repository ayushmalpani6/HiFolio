//
//  LoginView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/17/23.
//

import SwiftUI


struct LoginView: View  {
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.vertical, 40)
                
                // form field
                InputView(label: "Email Address",
                          placeholder: "example@email.com",
                          inputText: $emailInput)
                .textInputAutocapitalization(.never)
                .padding(.bottom, 20)
                
                InputView(label: "Password",
                          placeholder: "Enter Password",
                          inputText: $passwordInput,
                          isSecureField: true)
                .textInputAutocapitalization(.never)
                
                
                // MARK- sign in button
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: emailInput, password: passwordInput)
                    }
                } label: {
                    HStack {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                    }
                    .background(primaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                
                Spacer()
                
                // sign up button
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Don't have an account? **Sign Up**")
                        .foregroundStyle(primaryColor)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !emailInput.isEmpty && !passwordInput.isEmpty && emailInput.contains("@") && passwordInput.count > 5
    }
}

#Preview {
    LoginView()
}
