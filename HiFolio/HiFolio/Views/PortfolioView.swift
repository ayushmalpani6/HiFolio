//
//  PortfolioView.swift
//  HiFolio
//
//  Created by Ayush Malpani on 12/23/23.
//

import SwiftUI

struct SectionTitle: Identifiable {
    var title: String
    var checked: Bool
    var id: String { title }
}

struct PortfolioView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSetupSheet: Bool = false
    @State var sections: [SectionTitle] = [
        SectionTitle(title: "Education", checked: false),
        SectionTitle(title: "Awards & Honors", checked: false),
        SectionTitle(title: "Athletics", checked: false),
        SectionTitle(title: "Arts", checked: false),
        SectionTitle(title: "Clubs & Organizations", checked: false),
        SectionTitle(title: "Courses", checked: false),
        SectionTitle(title: "Projects", checked: false),
        SectionTitle(title: "Community Service", checked: false),
        SectionTitle(title: "Work Experience", checked: false)
    ]
    
    @State var showAddEducationEntryView: Bool = false
    
    var body: some View {
        ZStack {
            mainBody
            
            if showAddEducationEntryView {
                addEducationEntryView
            }
        }
    }
    
    
    var mainBody: some View {
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
                                VStack(alignment: .leading) {
                                    if viewModel.currentUserPortfolio != nil{
                                        ForEach(viewModel.currentUserPortfolio!.getSectionEntries(sectionTitle: section.title), id: \.id) { entry in
                                            VStack {
                                                Text(entry.title)
                                                    .fontWeight(.semibold)
                                                Text(entry.date)
                                                    .fontWeight(.light)
                                                Text(entry.description)
                                                    .fontWeight(.regular)
                                            }
                                            .background(.gray)
                                            .padding(10)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                        }
                                    }
                                }
                                Button {
                                    showAddEducationEntryView.toggle()
                                } label : {
                                    Text("Add Entry")
                                        .fontWeight(.black)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                                .padding(.vertical, 5)
                                .tint(.cyan)
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
    }
    
    @State var schoolInput: String = ""
    @State var gpaInput: String = ""
    @State var startingDateInput: Date = Date()
    @State var endingDateInput: Date = Date()
    @State var attending: Bool = false
    
    var addEducationEntryView: some View {
            VStack(spacing: 20) {
                Image(systemName: "graduationcap.circle.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.vertical, 40)
                
                InputView(label: "Name of School", placeholder: "Enter your School Name", inputText: $schoolInput)
                    .textInputAutocapitalization(.never)
                
                Toggle("Currently attending this school?", isOn: $attending)
                    .padding(.horizontal, 30)
                    .foregroundStyle(.cyan)
                
                DatePicker(
                        "Start Date",
                        selection: $startingDateInput,
                        displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .foregroundStyle(.cyan)
                
                if !attending {
                    DatePicker(
                            "End Date",
                            selection: $endingDateInput,
                            displayedComponents: [.date]
                    )
                    .padding(.horizontal, 30)
                    .foregroundStyle(.cyan)
                }
                
                InputView(label: "GPA", placeholder: "Enter your GPA", inputText: $gpaInput)
                
                Button {
                    let newEntry: EducationEntry
                    if attending {
                        newEntry = EducationEntry(schoolName: schoolInput, startingDate: startingDateInput, gpa: gpaInput)
                    } else {
                        newEntry = EducationEntry(schoolName: schoolInput, startingDate: startingDateInput, endingDate: endingDateInput, gpa: gpaInput)
                    }
                    
                    viewModel.currentUserPortfolio?.education.entries.append(newEntry)
                    
                    Task {
                        await viewModel.updatePortfolio()
                    }
                    
                    showAddEducationEntryView.toggle()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                }
                .background(.cyan)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .background(.white)
        }
}

struct SetupSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sections: [SectionTitle]
    
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
        }
    }
}



//#Preview {
//    PortfolioView()
//}
