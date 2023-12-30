//
//  InputView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/17/23.
//

import SwiftUI

struct InputView: View {
    var label: String
    var placeholder: String
    @Binding var inputText: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .fontWeight(.semibold)
                .foregroundStyle(.cyan)
                
            if isSecureField {
                SecureField(label, text: $inputText, prompt: Text(placeholder))
                    .fontWeight(.thin)
            } else{
                TextField(label, text: $inputText, prompt: Text(placeholder))
                        .fontWeight(.thin)
            }
            Divider()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    VStack {
        InputView(label: "Email Address", placeholder: "example@fbla.com", inputText: .constant(""))
        InputView(label: "Password", placeholder: "Enter Password", inputText: .constant(""), isSecureField: true)
    }
}
