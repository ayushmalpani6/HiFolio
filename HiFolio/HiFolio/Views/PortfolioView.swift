//
//  PortfolioView.swift
//  HiFolio
//
//  Created by Jugal Malpani on 12/23/23.
//

import SwiftUI

struct SectionItem: Identifiable {
    var title: String
    var checked: Bool
    var id: String { title }
}



struct PortfolioView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSetupSheet: Bool = false
    @State var sections: [SectionItem] = [
        SectionItem(title: "About", checked: false),
        SectionItem(title: "Education", checked: false),
        SectionItem(title: "Awards & Honors", checked: false),
        SectionItem(title: "Athletics", checked: false),
        SectionItem(title: "Arts", checked: false),
        SectionItem(title: "Clubs & Organizations", checked: false),
        SectionItem(title: "Courses", checked: false),
        SectionItem(title: "Projects", checked: false),
        SectionItem(title: "Work Experience", checked: false)
    ]
    
    
    var body: some View {
        ScrollView {
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
                    Spacer()
                    Button {
                        showSetupSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundStyle(Color(.black))
                            .padding(.horizontal, 20)
                    }
                }
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                    VStack (alignment: .leading) {
                        Text("Hi I'm \(viewModel.currentUser?.fullName ?? "")")
                            .font(.system(size: 14))
                        Text("")
                        Text(viewModel.currentUser?.emailAddress ?? "")
                            .font(.system(size: 14))
                        Text("")
                        Text("Class of 20XX")
                            .font(.system(size: 14))
                    }
                    .padding(.trailing, 20)
                }
                .background(.cyan)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 10)
                
                GroupBox {
                    ForEach(sections) { section in
                        if section.checked {
                            DisclosureGroup(section.title) {
                                Text("EDITABLE TEXT")
                                    .padding(.vertical, 5)
                                    .fontWeight(.light)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                                .padding(.vertical, 5)
                                .tint(.cyan)
                                .fontWeight(.black)
                        }
                    }
                }
                .backgroundStyle(.white)
                Spacer()
            }
        }
        .sheet(isPresented: $showSetupSheet, content: {
            SetupSheet(sections: $sections)
        })
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

struct SetupSheet : View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sections: [SectionItem]
    
    var body: some View {

        VStack(alignment: .trailing) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .padding(.vertical, 15)
                    .padding(.trailing, 15)
                    .foregroundColor(.cyan)
            }
            
            ForEach(sections.indices) { index in
                   Button {
                       sections[index].checked.toggle()
                   } label: {
                       HStack {
                           Text(sections[index].title)
                               .fontWeight(.bold)
                               .font(.system(size: 15))
                               .foregroundStyle(.cyan)
                               .padding(.horizontal, 20)
                           Spacer()
                           if sections[index].checked == false {
                               Image(systemName: "square")
                                   .foregroundStyle(.cyan)
                           } else {
                               Image(systemName: "checkmark.square.fill")
                                   .foregroundStyle(.cyan)
                           }
                       }
                   }
                   .padding(15)
                Divider()
            }
            Spacer()
            
//            HStack {
//                Text("Bibble Babble")
//                Spacer()
//                Button {
//                    x.toggle()
//                } label: {
//                    if x == false {
//                        Image(systemName: "square")
//                    } else {
//                        Image(systemName: "checkmark.square")
//                    }
//                }
//            }
            
        }
    }
}

#Preview {
    PortfolioView()
}
