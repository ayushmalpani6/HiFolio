//
//  PortfolioView.swift
//  HiFolio
//
//  Created by Jugal Malpani on 12/23/23.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Folio")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                    .frame(width: 150, height: 50)
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
            }
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                VStack (alignment: .leading) {
                    Text("Hi I'm XXXXX")
                    Text(verbatim: "XXXXX@gmail.com")
                    Text("Class of 20XX")
                }
                .padding(.trailing, 20)
            }
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 10)
            GroupBox {
                DisclosureGroup ("Background") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                Divider()
                DisclosureGroup ("Achievements") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                Divider()
                DisclosureGroup ("Athletics & Arts") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                Divider()
                DisclosureGroup ("Clubs") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                Divider()
                DisclosureGroup ("Community Service") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                Divider()
                DisclosureGroup ("APs and Honors") {
                    Text("EDITABLE TEXT")
                        .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
            }
            Spacer()
        }
//        NavigationStack {
//            ScrollView {
//                NavigationLink {
//                    Text("Background")
//                } label: {
//                    Text("Background")
//                }
//                
//                NavigationLink {
//                    Text("Achievements")
//                } label: {
//                    Text("Achievements")
//                }
//                
//                NavigationLink {
//                    Text("Athletics & Arts")
//                } label: {
//                    Text("Athletics & Arts")
//                }
//                
//                NavigationLink {
//                    Text("Clubs")
//                } label: {
//                    Text("Clubs")
//                }
//                
//                NavigationLink {
//                    Text("Community Service")
//                } label: {
//                    Text("Community Service")
//                }
//                
//                NavigationLink {
//                    Text("APs & Honors")
//                } label : {
//                    Text("APs & Honors")
//                }
//            }
//        }
    }
}

#Preview {
    PortfolioView()
}
